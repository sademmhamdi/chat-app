enum ChatType { direct, group }

class ChatRoomModel {
  final String id;
  final String name;
  final ChatType type;
  final List<String> participants;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final String createdBy;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.participants,
    this.lastMessage,
    required this.lastMessageTime,
    required this.createdBy,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: ChatType.values[map['type'] ?? 0],
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'],
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] ?? 0),
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'createdBy': createdBy,
    };
  }
}