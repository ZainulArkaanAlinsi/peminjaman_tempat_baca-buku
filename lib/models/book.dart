class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String category;
  final int pages;
  final double rating;
  final int totalReaders;
  final bool isPublic;
  final List<Chapter> chapters;
  final DateTime publishedDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.pages,
    required this.rating,
    required this.totalReaders,
    required this.isPublic,
    required this.chapters,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      category: json['category'] ?? '',
      pages: json['pages'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReaders: json['totalReaders'] ?? 0,
      isPublic: json['isPublic'] ?? true,
      chapters: (json['chapters'] as List?)
              ?.map((c) => Chapter.fromJson(c))
              .toList() ??
          [],
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'category': category,
      'pages': pages,
      'rating': rating,
      'totalReaders': totalReaders,
      'isPublic': isPublic,
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'publishedDate': publishedDate.toIso8601String(),
    };
  }
}

class Chapter {
  final String id;
  final String title;
  final String content;
  final int chapterNumber;

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.chapterNumber,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      chapterNumber: json['chapterNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'chapterNumber': chapterNumber,
    };
  }
}
