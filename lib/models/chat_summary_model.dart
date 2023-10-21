import 'package:pegasus_tool/screens/pool/chat/room_type.dart';

class ChatRoomTemplate {
  final String? id;
  final String? name;
  final String? description;
  final RoomType? type;
  final num? minActiveStake;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const ChatRoomTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.minActiveStake,
  });

  ChatRoomTemplate copyWith({
    String? id,
    String? name,
    String? description,
    RoomType? type,
    num? minActiveStake,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (description == null || identical(description, this.description)) &&
        (type == null || identical(type, this.type)) &&
        (minActiveStake == null ||
            identical(minActiveStake, this.minActiveStake))) {
      return this;
    }

    return ChatRoomTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      minActiveStake: minActiveStake ?? this.minActiveStake,
    );
  }

  @override
  String toString() {
    return 'ChatRoomTemplate{id: $id, name: $name, description: $description, type: $type, minActiveStake: $minActiveStake}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRoomTemplate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          type == other.type &&
          minActiveStake == other.minActiveStake);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      type.hashCode ^
      minActiveStake.hashCode;

  factory ChatRoomTemplate.fromMap(Map<String, dynamic> map) {
    return ChatRoomTemplate(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      type: map['type'] as RoomType,
      minActiveStake: map['minActiveStake'] as num,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'minActiveStake': minActiveStake,
    } as Map<String, dynamic>;
  }

//</editor-fold>
}
