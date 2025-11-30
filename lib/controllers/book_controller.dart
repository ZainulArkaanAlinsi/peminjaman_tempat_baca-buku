import 'package:get/get.dart';
import '../models/book.dart';
import '../services/openlibrary_service.dart';

class BookController extends GetxController {
  final OpenLibraryService _openLibraryService = OpenLibraryService();

  final RxList<Book> allBooks = <Book>[].obs;
  final RxList<Book> filteredBooks = <Book>[].obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<Book?> selectedBook = Rx<Book?>(null);

  @override
  void onInit() {
    super.onInit();
    loadBooksFromOpenLibrary();
  }

  // Load books from Open Library
  Future<void> loadBooksFromOpenLibrary() async {
    try {
      isLoading.value = true;

      final books = await _openLibraryService.getAllBooks();

      if (books.isNotEmpty) {
        allBooks.value = books;
        filteredBooks.value = books;

        Get.snackbar(
          'Sukses',
          'Berhasil memuat ${books.length} buku dari Open Library',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Fallback ke dummy
        allBooks.value = generateDummyBooks();
        filteredBooks.value = allBooks;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat buku: $e');
      // Fallback ke dummy
      allBooks.value = generateDummyBooks();
      filteredBooks.value = allBooks;
    } finally {
      isLoading.value = false;
    }
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;

    if (category == 'Semua') {
      filteredBooks.value = allBooks;
      return;
    }

    isLoading.value = true;
    try {
      final subject = category.toLowerCase();
      final books = await _openLibraryService.getBooksBySubject(subject);
      filteredBooks.value = books;
    } finally {
      isLoading.value = false;
    }
  }

  // Search books
  Future<void> searchBooks(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredBooks.value = allBooks;
      return;
    }

    if (query.length < 3) return; // Tunggu minimal 3 karakter

    isLoading.value = true;
    try {
      final books = await _openLibraryService.searchBooks(query);
      filteredBooks.value = books;
    } finally {
      isLoading.value = false;
    }
  }

  // Select book
  void selectBook(Book book) {
    selectedBook.value = book;
  }

  // Check access
  bool canReadBook(Book book) {
    return book.isPublic;
  }

  // Tetap pertahankan dummy data sebagai fallback
  List<Book> generateDummyBooks() {
    // ... existing dummy code ...
  }
}
