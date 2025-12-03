class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> favorites;
  final List<String> readingHistory;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.favorites = const [],
    this.readingHistory = const [],
  });

  // Convert User to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'favorites': favorites,
      'readingHistory': readingHistory,
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      favorites: List<String>.from(map['favorites'] ?? []),
      readingHistory: List<String>.from(map['readingHistory'] ?? []),
    );
  }

  // Copy with method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    List<String>? favorites,
    List<String>? readingHistory,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      favorites: favorites ?? this.favorites,
      readingHistory: readingHistory ?? this.readingHistory,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, favorites: ${favorites.length}, readingHistory: ${readingHistory.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.favorites == favorites &&
        other.readingHistory == readingHistory;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        favorites.hashCode ^
        readingHistory.hashCode;
  }
}
