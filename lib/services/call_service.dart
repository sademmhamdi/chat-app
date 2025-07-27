import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallService extends ChangeNotifier {
  RtcEngine? _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _videoDisabled = false;

  bool get localUserJoined => _localUserJoined;
  int? get remoteUid => _remoteUid;
  bool get muted => _muted;
  bool get videoDisabled => _videoDisabled;

  // TODO: Replace with your actual Agora App ID from https://console.agora.io/
  // This is a placeholder and needs to be configured for the app to work
  static const String appId = "YOUR_AGORA_APP_ID";

  Future<void> initializeAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          _remoteUid = null;
          notifyListeners();
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
  }

  Future<void> joinCall(String channelName, String token) async {
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveCall() async {
    await _engine!.leaveChannel();
    _localUserJoined = false;
    _remoteUid = null;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _muted = !_muted;
    await _engine!.muteLocalAudioStream(_muted);
    notifyListeners();
  }

  Future<void> switchCamera() async {
    await _engine!.switchCamera();
  }

  Future<void> toggleVideo() async {
    _videoDisabled = !_videoDisabled;
    await _engine!.muteLocalVideoStream(_videoDisabled);
    notifyListeners();
  }

  Widget buildLocalPreview() {
    if (_localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: ""),
        ),
      );
    } else {
      return const Center(
        child: Text('Waiting for remote user to join...'),
      );
    }
  }

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
  }
}