import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/novel.dart';
import '../models/category.dart' as app_models;
import '../models/chapter.dart' as app_models;
import '../providers/providers.dart';
import 'reading_screen.dart';

class DetailScreen extends StatefulWidget {
  final Novel novel;

  const DetailScreen({super.key, required this.novel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<app_models.Chapter> _chapters = [];
  bool _isLoadingChapters = false;
  bool _hasLoadedChapters = false;

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    if (_hasLoadedChapters) return;
    
    setState(() {
      _isLoadingChapters = true;
    });

    try {
      final novelProvider = context.read<NovelProviderBase>();
      // Get novel service dari provider
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Fetch chapters dari novel service
      final chapters = await novelProvider.getChapters(
        widget.novel.id,
        title: widget.novel.title,
        author: widget.novel.author,
      );
      
      setState(() {
        _chapters = chapters;
        _isLoadingChapters = false;
        _hasLoadedChapters = true;
      });
    } catch (e) {
      setState(() {
        _isLoadingChapters = false;
        _hasLoadedChapters = true;
      });
      print('Error loading chapters: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<FavoriteProviderBase>(
                builder: (context, favoriteProvider, child) {
                  final isFavorite = favoriteProvider.isFavorite(widget.novel.id);
                  return IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                    onPressed: () {
                      favoriteProvider.toggleFavorite(widget.novel);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite 
                                ? 'Dihapus dari favorite' 
                                : 'Ditambahkan ke favorite',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.novel.coverUrl.isNotEmpty
                        ? widget.novel.coverUrl
                        : 'https://via.placeholder.com/400x600?text=${Uri.encodeComponent(widget.novel.title)}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.book_outlined, size: 64),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Author
                  Text(
                    widget.novel.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.novel.author}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  _buildStatsRow(),
                  const SizedBox(height: 16),

                  // Category & Status (Separated)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.folder,
                          label: 'Category',
                          value: widget.novel.category,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.info_outline,
                          label: 'Status',
                          value: widget.novel.status == 'completed'
                              ? 'Completed'
                              : 'Ongoing',
                          color: widget.novel.status == 'completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Synopsis',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.novel.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadingScreen(
                                  novel: widget.novel,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_stories),
                          label: const Text('Baca'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<BookmarkProvider>(
                        builder: (context, bookmarkProvider, child) {
                          return IconButton.outlined(
                            onPressed: () {
                              _showBookmarkDialog(bookmarkProvider);
                            },
                            icon: const Icon(Icons.bookmark_add),
                            tooltip: 'Add to Bookmark',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Chapter List
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Chapters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_isLoadingChapters)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildChapterList(),
                  const SizedBox(height: 24),

                  // Last Updated
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Last updated: ${DateFormat('MMMM dd, yyyy').format(widget.novel.updatedAt)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          icon: Icons.star,
          color: Colors.amber[700]!,
          value: widget.novel.rating.toStringAsFixed(1),
          label: 'Rating',
        ),
        _buildStatItem(
          icon: Icons.menu_book,
          color: Colors.blue,
          value: '${widget.novel.chapters}',
          label: 'Chapters',
        ),
        _buildStatItem(
          icon: Icons.calendar_today,
          color: Colors.green,
          value: DateFormat('yyyy').format(widget.novel.createdAt),
          label: 'Year',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList() {
    return Container(
      height: 200, // Fixed height untuk scrollable area
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: _isLoadingChapters
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _chapters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'No chapters available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _chapters.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final chapter = _chapters[index];
                    return _buildChapterItem(chapter, index);
                  },
                ),
    );
  }

  Widget _buildChapterItem(app_models.Chapter chapter, int index) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        chapter.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${chapter.wordCount} words',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[600],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadingScreen(
              novel: widget.novel,
              chapterIndex: index,
            ),
          ),
        );
      },
    );
  }

  void _showBookmarkDialog(BookmarkProvider bookmarkProvider) {
    final bookmarks = bookmarkProvider.bookmarks;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add to Bookmark',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (bookmarks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text('Belum ada bookmark. Buat bookmark terlebih dahulu.'),
                ),
              )
            else
              ...bookmarks.map((bookmark) {
                final bookmarkName = bookmark['name'] ?? 'Unnamed';
                return ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: Text(bookmarkName.toString()),
                  onTap: () {
                    bookmarkProvider.addNovelToBookmark(
                      bookmark['id'].toString(),
                      widget.novel.id,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ditambahkan ke $bookmarkName'),
                      ),
                    );
                  },
                );
              }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showCreateBookmarkDialog(bookmarkProvider);
                },
                icon: const Icon(Icons.add),
                label: const Text('Buat Bookmark Baru'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBookmarkDialog(BookmarkProvider bookmarkProvider) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Bookmark Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Bookmark',
                hintText: 'Contoh: Favorit, To Read',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (Opsional)',
                hintText: 'Deskripsi bookmark',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                bookmarkProvider.createBookmark(
                  nameController.text,
                  descController.text,
                );
                bookmarkProvider.addNovelToBookmark(
                  bookmarkProvider.bookmarks.last['id'].toString(),
                  widget.novel.id,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bookmark berhasil dibuat'),
                  ),
                );
              }
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}
