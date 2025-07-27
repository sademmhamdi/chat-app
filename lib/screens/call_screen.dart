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
                          child: Icon(Icons.person, size: 64, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Audio Call',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        SizedBox(height: 8),
                        Text(
                          callService.remoteUid != null ? 'Connected' : 'Connecting...',
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
                      backgroundColor: callService.muted ? Colors.red : Colors.grey[700],
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
                        backgroundColor: callService.videoDisabled ? Colors.red : Colors.grey[700],
                        child: Icon(
                          callService.videoDisabled ? Icons.videocam_off : Icons.videocam,
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
  },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.displayName,
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users to add...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(child: Text('Search for users to add to the group'))
                : StreamBuilder<List<UserModel>>(
                    stream: chatService.searchUsers(_searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No users found'));
                      }

                      final currentUserId = Provider.of<AuthService>(context, listen: false).user!.uid;
                      final users = snapshot.data!.where((user) => user.uid != currentUserId).toList();

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isSelected = _selectedUsers.any((u) => u.uid == user.uid);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[700],
                              child: Text(
                                user.displayName[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user.displayName),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.add_circle_outline),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedUsers.removeWhere((u) => u.uid == user.uid);
                                } else {
                                  _selectedUsers.add(user);
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _createGroup() async {
    if (_groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);

    final participants = [authService.user!.uid];
    participants.addAll(_selectedUsers.map((user) => user.uid));

    await chatService.createGroupChat(
      _groupNameController.text.trim(),
      participants,
      authService.user!.uid,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Group created successfully!')),
    );
  }
}
