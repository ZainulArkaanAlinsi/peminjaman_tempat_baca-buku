import 'package:buku_siap_pinjam/widgets/book_card.dart';
import 'package:buku_siap_pinjam/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/book_controller.dart';
import '../controllers/auth_controller.dart';
import '../app/routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final BookController bookController = Get.find<BookController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = authController.currentUser.value;
              return Text(
                'Halo, ${user?.name.split(' ').first ?? 'Pembaca'}!',
                style: Theme.of(context).textTheme.titleLarge,
              );
            }),
            Text(
              'Mau baca apa hari ini?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Iconsax.user),
            onPressed: () {
              Get.toNamed(Routes.profile);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const LoadingIndicator(message: 'Memuat buku...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories
              _buildCategoriesSection(context),

              const SizedBox(height: 32),

              // Featured Books
              _buildBooksSection(
                context,
                'Buku Populer',
                bookController.filteredBooks,
              ),

              const SizedBox(height: 32),

              // New Books
              _buildBooksSection(
                context,
                'Buku Terbaru',
                bookController.filteredBooks.take(10).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: Obx(() {
            // derive categories from available books to avoid depending on a missing getter
            final categories = bookController.filteredBooks
                .map((b) {
                  try {
                    return (b as dynamic).category as String?;
                  } catch (e) {
                    return null;
                  }
                })
                .where((c) => c != null)
                .cast<String>()
                .toSet()
                .toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    bookController.selectedCategory.value == category;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      bookController.filterByCategory(category);
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBooksSection(
    BuildContext context,
    String title,
    List<dynamic> books,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () {
                bookController.filterByCategory('Semua');
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: books.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return BookCard(book: book);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.book_saved,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada buku ditemukan',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kategori lain atau kata kunci berbeda',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Cari Buku'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan judul atau penulis...',
            prefixIcon: Icon(Iconsax.search_normal),
          ),
          onChanged: (query) {
            if (query.length >= 3) {
              bookController.searchBooks(query);
            }
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              bookController.searchBooks('');
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
