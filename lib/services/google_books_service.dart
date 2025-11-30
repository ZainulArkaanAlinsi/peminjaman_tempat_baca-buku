import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';
import '../utils/constants.dart';

class GoogleBooksService {
  // Ambil buku berdasarkan kategori
  Future<List<Book>> getBooksByCategory(
    String category, {
    int maxResults = 40,
  }) async {
    try {
      final query = category == 'Semua' ? 'books' : 'subject:$category';
      final url = Uri.parse(
        '${AppConstants.googleBooksUrl}/volumes?q=$query&maxResults=$maxResults&langRestrict=id',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];

        return items.map((item) => _convertToBook(item)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  // Convert Google Books format ke Book model
  Book _convertToBook(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: item['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      description: volumeInfo['description'] ?? 'No description available',
      coverUrl:
          imageLinks['thumbnail']?.replaceAll('http:', 'https:') ??
          'https://via.placeholder.com/400x600?text=No+Cover',
      category: (volumeInfo['categories'] as List?)?.first ?? 'General',
      pages: volumeInfo['pageCount'] ?? 0,
      rating: volumeInfo['averageRating']?.toDouble() ?? 4.0,
      totalReaders: volumeInfo['ratingsCount'] ?? 0,
      isPublic: true, // Google Books semua public
      chapters: _generateChaptersFromPreview(item),
      publishedDate: _parseDate(volumeInfo['publishedDate']),
    );
  }

  // Generate chapters dari preview
  List<Chapter> _generateChaptersFromPreview(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'] ?? {};
    final preview = volumeInfo['description'] ?? '';

    // Buat 5 chapter sample
    return List.generate(5, (index) {
      return Chapter(
        id: 'chapter_${index + 1}',
        title: 'Chapter ${index + 1}',
        content:
            '''
          <h2>Chapter ${index + 1}</h2>
          <p>$preview</p>
          <p>Untuk membaca buku lengkap, silakan kunjungi Google Books atau toko buku online.</p>
        ''',
        chapterNumber: index + 1,
      );
    });
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      final url = Uri.parse(
        '${AppConstants.googleBooksUrl}/volumes?q=$query&maxResults=40',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];

        return items.map((item) => _convertToBook(item)).toList();
      }

      return [];
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  // Get book detail
  Future<Book?> getBookDetail(String bookId) async {
    try {
      final url = Uri.parse('${AppConstants.googleBooksUrl}/volumes/$bookId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _convertToBook(data);
      }

      return null;
    } catch (e) {
      print('Error fetching book detail: $e');
      return null;
    }
  }
}
