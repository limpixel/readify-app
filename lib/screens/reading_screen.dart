import 'package:flutter/material.dart';
import '../models/novel.dart';
import '../services/gutenberg_service.dart';

/// Reading Screen - Menampilkan judul bab dan isi novel saja
/// UI sederhana fokus pada konten bacaan
///
/// Content diambil dari Project Gutenberg (full text)
class ReadingScreen extends StatefulWidget {
  final Novel novel;
  final int? chapterIndex; // Optional: index chapter untuk start reading

  const ReadingScreen({
    super.key,
    required this.novel,
    this.chapterIndex,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final GutenbergService _gutenbergService = GutenbergService();
  bool _isLoading = true;
  String _content = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);

    try {
      print('📖 Loading content: ${widget.novel.title}');

      // 1. Cek apakah novel sudah punya content
      if (widget.novel.content.isNotEmpty) {
        print('✅ Using cached content (${widget.novel.content.length} chars)');
        setState(() {
          _content = widget.novel.content;
          _isLoading = false;
        });
        return;
      }

      // 2. Extract Gutenberg ID
      int? gutenbergId;
      if (widget.novel.id.startsWith('gutenberg_')) {
        gutenbergId = int.tryParse(widget.novel.id.replaceFirst('gutenberg_', ''));
      } else if (widget.novel.gutenbergId != null) {
        gutenbergId = widget.novel.gutenbergId;
      }

      if (gutenbergId != null) {
        print('📚 Fetching from Gutenberg ID: $gutenbergId');
        final content = await _gutenbergService.getBookContent(gutenbergId);
        
        if (content != null && content.isNotEmpty) {
          print('✅ Got content: ${content.length} chars');
          setState(() {
            _content = content;
            _isLoading = false;
          });
          return;
        }
      }

      // 3. Fallback: gunakan description
      print('⚠️ No full content, using description');
      setState(() {
        _content = widget.novel.description.isNotEmpty
            ? widget.novel.description
            : 'Full content not available for this novel.';
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading content: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novel.title.length > 50 
            ? widget.novel.title.substring(0, 50) + '...'
            : widget.novel.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContent,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading novel content...'),
            SizedBox(height: 8),
            Text(
              'Downloading from Project Gutenberg',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading content',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadContent,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Title
          Text(
            'Chapter 1',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Novel info (small)
          Text(
            widget.novel.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'by ${widget.novel.author}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          
          // Divider
          const Divider(thickness: 2),
          const SizedBox(height: 24),
          
          // Content
          Text(
            _content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.8,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 16),
          
          // End marker
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 32),
                const SizedBox(height: 8),
                Text(
                  'End of Chapter 1',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Source: Project Gutenberg',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
