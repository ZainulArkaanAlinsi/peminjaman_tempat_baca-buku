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
    loadBooks();
  }

  // Load books dengan fallback ke dummy
  Future<void> loadBooks() async {
    isLoading.value = true;

    try {
      // Coba load dari Open Library
      final books = await _openLibraryService.getAllBooks().timeout(
        const Duration(seconds: 5),
      );

      if (books.isNotEmpty) {
        allBooks.value = books;
        filteredBooks.value = books;
        Get.snackbar(
          'Sukses',
          'Berhasil memuat ${books.length} buku dari Open Library',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        _loadDummyBooks();
      }
    } catch (e) {
      print('Error loading books: $e');
      _loadDummyBooks();
    } finally {
      isLoading.value = false;
    }
  }

  // Load dummy books
  void _loadDummyBooks() {
    allBooks.value = generateDummyBooks();
    filteredBooks.value = allBooks;
    Get.snackbar(
      'Mode Offline',
      'Menampilkan ${allBooks.length} buku dari koleksi lokal',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedCategory.value = category;

    if (category == 'Semua') {
      filteredBooks.value = allBooks;
    } else {
      filteredBooks.value = allBooks
          .where(
            (book) => book.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();
    }
  }

  // Search books
  void searchBooks(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredBooks.value = allBooks;
      return;
    }

    filteredBooks.value = allBooks.where((book) {
      final titleMatch = book.title.toLowerCase().contains(query.toLowerCase());
      final authorMatch = book.author.toLowerCase().contains(
        query.toLowerCase(),
      );
      return titleMatch || authorMatch;
    }).toList();
  }

  // Select book
  void selectBook(Book book) {
    selectedBook.value = book;
  }

  // Check access
  bool canReadBook(Book book) {
    return book.isPublic;
  }

  // Generate 100+ dummy books
  List<Book> generateDummyBooks() {
    final categories = [
      'Fiction',
      'Science',
      'History',
      'Biography',
      'Business',
      'Technology',
      'Fantasy',
      'Romance',
      'Thriller',
      'Philosophy',
    ];

    final titlePrefixes = [
      'The Great',
      'Journey to',
      'Mystery of',
      'Rise of',
      'Fall of',
      'Art of',
      'Science of',
      'Power of',
      'Secret of',
      'Life of',
      'Tales from',
      'Chronicles of',
      'History of',
      'Guide to',
      'Mastering',
      'Introduction to',
      'Advanced',
      'Complete',
      'Essential',
      'Modern',
    ];

    final titleSuffixes = [
      'Adventure',
      'Discovery',
      'Innovation',
      'Revolution',
      'Transformation',
      'Success',
      'Leadership',
      'Creativity',
      'Knowledge',
      'Wisdom',
      'Empire',
      'Kingdom',
      'Universe',
      'Reality',
      'Dreams',
      'Future',
      'Past',
      'Present',
      'Tomorrow',
      'Yesterday',
    ];

    final authors = [
      'John Smith',
      'Sarah Johnson',
      'Michael Brown',
      'Emily Davis',
      'Robert Wilson',
      'Lisa Anderson',
      'David Martinez',
      'Jennifer Taylor',
      'William Moore',
      'Jessica Garcia',
      'James Rodriguez',
      'Amanda White',
      'Christopher Lee',
      'Melissa Harris',
      'Daniel Clark',
      'Patricia Lewis',
      'Matthew Walker',
      'Laura Hall',
      'Andrew Allen',
      'Karen Young',
    ];

    List<Book> books = [];
    int bookId = 1;

    // Generate 120 books
    for (int i = 0; i < 120; i++) {
      final category = categories[i % categories.length];
      final prefix = titlePrefixes[i % titlePrefixes.length];
      final suffix = titleSuffixes[i % titleSuffixes.length];
      final author = authors[i % authors.length];

      books.add(
        Book(
          id: 'book_$bookId',
          title: '$prefix $suffix',
          author: author,
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
          coverUrl:
              'https://picsum.photos/seed/$bookId/400/600', // Random cover
          category: category,
          pages: 150 + (i * 17) % 450, // 150-600 pages
          rating: 3.5 + (i % 15) / 10, // 3.5-5.0 rating
          totalReaders: 500 + (i * 73) % 5000, // 500-5500 readers
          isPublic: true,
          chapters: _generateChapters(bookId),
          publishedDate: DateTime.now().subtract(Duration(days: i * 7)),
        ),
      );

      bookId++;
    }

    return books;
  }

  // Generate chapters for a book
  List<Chapter> _generateChapters(int bookId) {
    return List.generate(15, (index) {
      return Chapter(
        id: 'chapter_${bookId}_${index + 1}',
        title: 'Chapter ${index + 1}: ${_getChapterTitle(index + 1)}',
        content: _generateChapterContent(index + 1),
        chapterNumber: index + 1,
      );
    });
  }

  String _getChapterTitle(int num) {
    final titles = [
      'The Beginning',
      'New Horizons',
      'The Challenge',
      'Discovery',
      'Journey',
      'Obstacles',
      'Friendship',
      'Conflict',
      'Mystery',
      'Revelation',
      'Transformation',
      'Climax',
      'Resolution',
      'New Dawn',
      'Epilogue',
    ];
    return titles[(num - 1) % titles.length];
  }

  String _generateChapterContent(int chapterNum) {
    return '''
      <h2>Chapter $chapterNum</h2>
      <p style="text-align: justify; line-height: 1.8; margin-bottom: 16px;">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod 
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, 
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      </p>
      <p style="text-align: justify; line-height: 1.8; margin-bottom: 16px;">
        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore 
        eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt 
        in culpa qui officia deserunt mollit anim id est laborum.
      </p>
      <p style="text-align: justify; line-height: 1.8; margin-bottom: 16px;">
        Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium 
        doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore 
        veritatis et quasi architecto beatae vitae dicta sunt explicabo.
      </p>
      <p style="text-align: justify; line-height: 1.8; margin-bottom: 16px;">
        Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, 
        sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
      </p>
      <p style="text-align: justify; line-height: 1.8; margin-bottom: 16px;">
        Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, 
        adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et 
        dolore magnam aliquam quaerat voluptatem.
      </p>
    ''';
  }
}
