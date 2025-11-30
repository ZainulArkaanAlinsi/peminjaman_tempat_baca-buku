import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class OpenLibraryService {
  static const String baseUrl = 'https://openlibrary.org';

  // Subjects populer untuk mendapatkan banyak buku
  static const List<String> subjects = [
    'fiction',
    'science',
    'history',
    'fantasy',
    'romance',
    'thriller',
    'biography',
    'business',
    'technology',
    'philosophy',
  ];

  // Ambil 100+ buku dari berbagai kategori
  Future<List<Book>> getAllBooks() async {
    List<Book> allBooks = [];

    try {
      // Load dari beberapa subject untuk dapat 100+ buku
      for (var subject in subjects.take(5)) {
        final books = await getBooksBySubject(subject, limit: 25);
        allBooks.addAll(books);

        if (allBooks.length >= 120) break;
      }

      return allBooks.take(120).toList();
    } catch (e) {
      print('Error fetching all books: $e');
      return [];
    }
  }

  // Ambil buku berdasarkan subject
  Future<List<Book>> getBooksBySubject(String subject, {int limit = 20}) async {
    try {
      final url = Uri.parse('$baseUrl/subjects/$subject.json?limit=$limit');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final works = data['works'] as List? ?? [];

        return works.map((work) => _convertToBook(work, subject)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching books by subject: $e');
      return [];
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      final url = Uri.parse('$baseUrl/search.json?q=$query&limit=40');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List? ?? [];

        return docs.map((doc) => _convertSearchResultToBook(doc)).toList();
      }

      return [];
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  // Convert Open Library work to Book model
  Book _convertToBook(Map<String, dynamic> work, String category) {
    final coverId = work['cover_id'];
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : 'https://via.placeholder.com/400x600?text=No+Cover';

    return Book(
      id: work['key']?.toString().replaceAll('/works/', '') ?? '',
      title: work['title'] ?? 'No Title',
      author:
          (work['authors'] as List?)?.map((a) => a['name']).join(', ') ??
          'Unknown Author',
      description: work['description'] is String
          ? work['description']
          : (work['description']?['value'] ?? 'No description available'),
      coverUrl: coverUrl,
      category: _capitalizeFirst(category),
      pages: work['number_of_pages_median']?.toInt() ?? 250,
      rating: 4.0 + (work['key'].hashCode % 10) / 10, // Random 4.0-4.9
      totalReaders: 1000 + (work['key'].hashCode % 5000),
      isPublic: true,
      chapters: _generateSampleChapters(work['title'] ?? 'Book'),
      publishedDate: _parseYear(work['first_publish_year']),
    );
  }

  // Convert search result to Book
  Book _convertSearchResultToBook(Map<String, dynamic> doc) {
    final coverId = doc['cover_i'];
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : 'https://via.placeholder.com/400x600?text=No+Cover';

    return Book(
      id: doc['key']?.toString().replaceAll('/works/', '') ?? '',
      title: doc['title'] ?? 'No Title',
      author: (doc['author_name'] as List?)?.join(', ') ?? 'Unknown Author',
      description:
          (doc['first_sentence'] as List?)?.join(' ') ??
          'No description available',
      coverUrl: coverUrl,
      category: (doc['subject'] as List?)?.first ?? 'General',
      pages: doc['number_of_pages_median']?.toInt() ?? 250,
      rating: 4.0 + (doc['key'].hashCode % 10) / 10,
      totalReaders: 1000 + (doc['key'].hashCode % 5000),
      isPublic: true,
      chapters: _generateSampleChapters(doc['title'] ?? 'Book'),
      publishedDate: _parseYear(doc['first_publish_year']),
    );
  }

  // Generate sample chapters
  List<Chapter> _generateSampleChapters(String bookTitle) {
    return List.generate(10, (index) {
      return Chapter(
        id: 'chapter_${index + 1}',
        title: 'Chapter ${index + 1}: ${_getChapterTitle(index + 1)}',
        content:
            '''
          <h2>Chapter ${index + 1}</h2>
          <p>This is a sample chapter from "$bookTitle".</p>
          <p>Open Library provides metadata and covers, but full text reading 
          requires visiting the original source or purchasing the book.</p>
          <p>You can implement full text reading by:</p>
          <ul>
            <li>Integrating with Internet Archive for public domain books</li>
            <li>Connecting to publisher APIs for licensed content</li>
            <li>Allowing users to upload their own content</li>
          </ul>
        ''',
        chapterNumber: index + 1,
      );
    });
  }

  String _getChapterTitle(int num) {
    final titles = [
      'The Beginning',
      'Discovery',
      'The Challenge',
      'Mystery Unfolds',
      'Journey',
      'Obstacles',
      'Friendship',
      'Conflict',
      'Climax',
      'Resolution',
    ];
    return titles[(num - 1) % titles.length];
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  DateTime _parseYear(int? year) {
    if (year == null) return DateTime.now();
    return DateTime(year);
  }

  // Get book detail with full chapters
  Future<Book?> getBookDetail(String bookKey) async {
    try {
      final url = Uri.parse('$baseUrl/works/$bookKey.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _convertToBook(data, 'General');
      }

      return null;
    } catch (e) {
      print('Error fetching book detail: $e');
      return null;
    }
  }
}
