import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../models/book.dart' hide Chapter;
import '../models/chapter.dart';
import '../app/routes.dart';

class ChapterItem extends StatelessWidget {
  final Chapter chapter;
  final Book book;
  final bool isFirst;
  final bool isLast;

  const ChapterItem({
    super.key,
    required this.chapter,
    required this.book,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 0 : 4,
        bottom: isLast ? 16 : 4,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${chapter.chapterNumber}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          chapter.title,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _getChapterPreview(chapter.content),
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Iconsax.arrow_right_3, size: 20),
        onTap: () {
          Get.toNamed(Routes.reader, arguments: book);
        },
      ),
    );
  }

  String _getChapterPreview(String content) {
    // Remove HTML tags and get preview
    final cleanContent = content
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&');

    return cleanContent.length > 100
        ? '${cleanContent.substring(0, 100)}...'
        : cleanContent;
  }
}
