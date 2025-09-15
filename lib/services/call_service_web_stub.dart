// Web stub for Agora RTC Engine
// This file provides stub implementations for web builds where Agora is not supported

import 'package:flutter/material.dart';

class RtcEngineContext {
  const RtcEngineContext({
    required this.appId,
    required this.channelProfile,
  });

  final String appId;
  final dynamic channelProfile;
}

class ChannelProfileType {
  static const channelProfileLiveBroadcasting = null;
}

class ClientRoleType {
  static const clientRoleBroadcaster = null;
}

class RtcEngineEventHandler {
  RtcEngineEventHandler({
    this.onJoinChannelSuccess,
    this.onUserJoined,
    this.onUserOffline,
  });

  final Function? onJoinChannelSuccess;
  final Function? onUserJoined;
  final Function? onUserOffline;
}

class RtcConnection {
  const RtcConnection({required this.channelId});

  final String channelId;
}

class ChannelMediaOptions {
  const ChannelMediaOptions();
}

class VideoCanvas {
  const VideoCanvas({required this.uid});

  final int uid;
}

class VideoViewController {
  VideoViewController({
    required dynamic rtcEngine,
    required VideoCanvas canvas,
  });

  factory VideoViewController.remote({
    required dynamic rtcEngine,
    required VideoCanvas canvas,
    required RtcConnection connection,
  }) {
    return VideoViewController(rtcEngine: rtcEngine, canvas: canvas);
  }
}

class AgoraVideoView extends StatelessWidget {
  const AgoraVideoView({super.key, required this.controller});

  final VideoViewController controller;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Video not available on web'));
  }
}

class UserOfflineReasonType {
  static const reasonQuit = null;
}

dynamic createAgoraRtcEngine() {
  return null;
}
