import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final bool isVideoCall;

  const CallScreen({
    Key? key,
    required this.channelName,
    this.isVideoCall = true,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    final callService = Provider.of<CallService>(context, listen: false);
    await callService.initializeAgora();
    await callService.joinCall(widget.channelName, ''); // Add your token here
  }

  @override
  void dispose() {
    Provider.of<CallService>(context, listen: false).leaveCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<CallService>(
        builder: (context, callService, child) {
          return Stack(
            children: [
              // Remote video (full screen)
              if (widget.isVideoCall)
                callService.buildRemoteVideo()
              else
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.grey[700],
                          child:
                              Icon(Icons.person, size: 64, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Audio Call',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        SizedBox(height: 8),
                        Text(
                          callService.remoteUid != null
                              ? 'Connected'
                              : 'Connecting...',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

              // Local video (small preview in corner)
              if (widget.isVideoCall)
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: callService.buildLocalPreview(),
                    ),
                  ),
                ),

              // Call controls
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    FloatingActionButton(
                      onPressed: callService.toggleMute,
                      backgroundColor:
                          callService.muted ? Colors.red : Colors.grey[700],
                      child: Icon(
                        callService.muted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                    ),

                    // End call button
                    FloatingActionButton(
                      onPressed: () {
                        callService.leaveCall();
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end, color: Colors.white),
                    ),

                    // Video toggle button (only for video calls)
                    if (widget.isVideoCall)
                      FloatingActionButton(
                        onPressed: callService.toggleVideo,
                        backgroundColor: callService.videoDisabled
                            ? Colors.red
                            : Colors.grey[700],
                        child: Icon(
                          callService.videoDisabled
                              ? Icons.videocam_off
                              : Icons.videocam,
                          color: Colors.white,
                        ),
                      ),

                    // Switch camera button (only for video calls)
                    if (widget.isVideoCall)
                      FloatingActionButton(
                        onPressed: callService.switchCamera,
                        backgroundColor: Colors.grey[700],
                        child: Icon(Icons.flip_camera_ios, color: Colors.white),
                      ),
                  ],
                ),
              ),

              // Call status
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    callService.remoteUid != null
                        ? 'Connected to ${widget.channelName}'
                        : 'Waiting for others to join...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
