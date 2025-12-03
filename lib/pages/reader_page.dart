import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/book_controller.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required book});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final BookController bookController = Get.find<BookController>();
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    currentPage = args?['chapterIndex'] ?? 0;
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final book = bookController.selectedBook.value;

      if (book == null || book.chapters.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Reader')),
          body: const Center(child: Text('Buku tidak ditemukan')),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(book.title),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.setting_2),
              onPressed: () => _showReaderSettings(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (currentPage + 1) / book.chapters.length,
              backgroundColor: Colors.grey.shade200,
            ),

            // Chapter Content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: book.chapters.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  final chapter = book.chapters[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Html(
                          data: chapter.content,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: LineHeight(1.8),
                            ),
                            "p": Style(
                              margin: Margins.only(bottom: 16),
                            ),
                            "h2": Style(
                              fontSize: FontSize(24),
                              fontWeight: FontWeight.bold,
                              margin: Margins.only(bottom: 16),
                            ),
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Navigation Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous Button
                    ElevatedButton.icon(
                      onPressed: currentPage > 0
                          ? () {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_left_2),
                      label: const Text('Sebelumnya'),
                    ),

                    // Page Info
                    Text(
                      '${currentPage + 1} / ${book.chapters.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    // Next Button
                    ElevatedButton.icon(
                      onPressed: currentPage < book.chapters.length - 1
                          ? () {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_right_3),
                      label: const Text('Selanjutnya'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showReaderSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Pembaca',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Iconsax.text),
              title: const Text('Ukuran Teks'),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Fitur segera hadir');
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.colorfilter),
              title: const Text('Tema Warna'),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Fitur segera hadir');
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.sun_1),
              title: const Text('Kecerahan'),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Fitur segera hadir');
              },
            ),
          ],
        ),
      ),
    );
  }
}
