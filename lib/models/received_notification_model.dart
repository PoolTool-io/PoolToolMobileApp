class ReceivedNotification {
  int id;
  String? title;
  String? body;
  String? payload;

//<editor-fold desc="Data Methods">

  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivedNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          payload == other.payload);

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ body.hashCode ^ payload.hashCode;

  @override
  String toString() {
    return 'ReceivedNotification{ id: $id, title: $title, body: $body, payload: $payload,}';
  }

  ReceivedNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) {
    return ReceivedNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
    };
  }

  factory ReceivedNotification.fromMap(Map<String, dynamic> map) {
    return ReceivedNotification(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      payload: map['payload'] as String,
    );
  }

//</editor-fold>
}
