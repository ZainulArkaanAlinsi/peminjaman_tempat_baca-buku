class Chapter {
  final String id;
  final String title;
  final String content;
  final int chapterNumber;

  const Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.chapterNumber,
  });

  // Convert Chapter to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'chapterNumber': chapterNumber,
    };
  }

  // Create Chapter from Map
  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      chapterNumber: map['chapterNumber']?.toInt() ?? 0,
    );
  }

  // Copy with method
  Chapter copyWith({
    String? id,
    String? title,
    String? content,
    int? chapterNumber,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      chapterNumber: chapterNumber ?? this.chapterNumber,
    );
  }

  @override
  String toString() {
    return 'Chapter(id: $id, title: $title, chapterNumber: $chapterNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.chapterNumber == chapterNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        chapterNumber.hashCode;
  }
}
