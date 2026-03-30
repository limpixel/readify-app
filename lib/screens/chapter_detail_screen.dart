import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/novel.dart';
import '../models/chapter.dart';

/// Screen untuk menampilkan detail chapter
/// Hanya menampilkan isi dari chapter tersebut
class ChapterDetailScreen extends StatelessWidget {
  final Chapter chapter;
  final Novel novel;

  const ChapterDetailScreen({
    super.key,
    required this.chapter,
    required this.novel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark chapter ini
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chapter bookmarked')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: novel.coverUrl.isNotEmpty
                          ? novel.coverUrl
                          : 'https://via.placeholder.com/60x90',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 50,
                        height: 75,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chapter ${chapter.number}: ${chapter.title}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Chapter Content
            Text(
              chapter.content,
              style: const TextStyle(
                fontSize: 16,
                height: 2.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            // End of Chapter
            Center(
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 16),
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(height: 8),
                  Text(
                    'End of Chapter ${chapter.number}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
