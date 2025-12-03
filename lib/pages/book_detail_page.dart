import 'package:buku_siap_pinjam/app/routes.dart';
import 'package:buku_siap_pinjam/widgets/chapter_item.dart';
import 'package:buku_siap_pinjam/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../models/book.dart';
import '../controllers/book_controller.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.find<BookController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Book Cover Background
                  Image.network(
                    book.coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Iconsax.book, size: 60),
                      );
                    },
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.heart),
                onPressed: () {
                  Get.snackbar('Info', 'Fitur favorit segera hadir');
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),

                  const SizedBox(height: 8),

                  // Author
                  Text(
                    'Oleh ${book.author}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Book Stats
                  Row(
                    children: [
                      _buildStatItem(
                        context,
                        Iconsax.star,
                        '${book.rating}',
                        'Rating',
                      ),
                      _buildStatItem(
                        context,
                        Iconsax.people,
                        '${book.totalReaders}',
                        'Pembaca',
                      ),
                      _buildStatItem(
                        context,
                        Iconsax.document,
                        '${book.pages}',
                        'Halaman',
                      ),
                      _buildStatItem(
                        context,
                        Iconsax.category,
                        book.category,
                        'Kategori',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 32),

                  // Chapters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Isi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${book.chapters.length} Bab',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Chapters List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chapter = book.chapters[index];
              return ChapterItem(
                chapter: chapter as dynamic,
                book: book,
                isFirst: index == 0,
                isLast: index == book.chapters.length - 1,
              );
            }, childCount: book.chapters.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Read Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: CustomButton(
          text: 'Baca Sekarang',
          onPressed: () {
            if (bookController.canReadBook(book)) {
              Get.toNamed(Routes.reader, arguments: book);
            } else {
              Get.snackbar(
                'Akses Dibatasi',
                'Buku ini tidak tersedia untuk dibaca',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          icon: Iconsax.book_1,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
