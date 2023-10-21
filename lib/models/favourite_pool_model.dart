class FavouritePool {
  String id;

//<editor-fold desc="Data Methods">

  FavouritePool({
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavouritePool &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FavouritePool{ id: $id,}';
  }

  FavouritePool copyWith({
    String? id,
  }) {
    return FavouritePool(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory FavouritePool.fromMap(Map<String, dynamic> map) {
    return FavouritePool(
      id: map['id'] as String,
    );
  }

//</editor-fold>
}
