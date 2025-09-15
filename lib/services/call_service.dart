import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for Agora - only available on mobile
import 'package:agora_rtc_engine/agora_rtc_engine.dart'
    if (dart.library.html) 'package:chattach/services/call_service_web_stub.dart';

import '../utils/constants.dart';

class CallService extends ChangeNotifier {
  dynamic _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _videoDisabled = false;

  bool get localUserJoined => _localUserJoined;
  int? get remoteUid => _remoteUid;
  bool get muted => _muted;
  bool get videoDisabled => _videoDisabled;
  bool get isWeb => kIsWeb;

  // Agora App ID from environment or constants
  static String get appId => AppConstants.agoraAppId;

  Future<void> initializeAgora() async {
    if (kIsWeb) {
      // Web stub - video calling not supported
      _localUserJoined = false;
      notifyListeners();
      return;
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
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
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _remoteUid = null;
          notifyListeners();
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
  }

  Future<void> joinCall(String channelName, String token) async {
    if (kIsWeb) {
      // Web stub - show message that video calling is not supported
      return;
    }

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveCall() async {
    if (kIsWeb) {
      _localUserJoined = false;
      _remoteUid = null;
      notifyListeners();
      return;
    }

    await _engine!.leaveChannel();
    _localUserJoined = false;
    _remoteUid = null;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    if (kIsWeb) {
      _muted = !_muted;
      notifyListeners();
      return;
    }

    _muted = !_muted;
    await _engine!.muteLocalAudioStream(_muted);
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (kIsWeb) {
      // No-op on web
      return;
    }

    await _engine!.switchCamera();
  }

  Future<void> toggleVideo() async {
    if (kIsWeb) {
      _videoDisabled = !_videoDisabled;
      notifyListeners();
      return;
    }

    _videoDisabled = !_videoDisabled;
    await _engine!.muteLocalVideoStream(_videoDisabled);
    notifyListeners();
  }

  Widget buildLocalPreview() {
    if (kIsWeb) {
      return const Center(
        child: Text('Video calling not supported on web'),
      );
    }

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
    if (kIsWeb) {
      return const Center(
        child: Text('Video calling not supported on web'),
      );
    }

    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid!),
          connection: const RtcConnection(channelId: ""),
        ),
      );
    } else {
      return const Center(
        child: Text('Waiting for remote user to join...'),
      );
    }
  }

  @override
  Future<void> dispose() async {
    if (kIsWeb) {
      super.dispose();
      return;
    }

    await _engine?.leaveChannel();
    await _engine?.release();
    super.dispose();
  }
}
