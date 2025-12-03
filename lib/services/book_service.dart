import '../models/book.dart';

abstract class BookService {
  Future<List<Book>> getAllBooks();
  Future<List<Book>> getBooksByCategory(String category);
  Future<List<Book>> searchBooks(String query);
  Future<Book?> getBookDetail(String bookId);
}

class MockBookService implements BookService {
  @override
  Future<List<Book>> getAllBooks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<List<Book>> getBooksByCategory(String category) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<Book?> getBookDetail(String bookId) async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}
