import 'dart:async';

import '../models/novel.dart';
import '../models/category.dart' as app_models;
import '../models/chapter.dart' as app_models;
import 'gutendex_api_service.dart';
import '../constants/api_constants.dart';

/// Service untuk mengelola novel menggunakan Gutendex API (Project Gutenberg)
/// Dokumentasi: https://gutendex.com/
/// Provides: Metadata + FULL TEXT content (public domain books)
class NovelService {
  final GutendexApiService _gutendexApi;

  NovelService() : _gutendexApi = GutendexApiService();

  /// Get semua novel dari Gutendex (popular books)
  Future<List<Novel>> getAllNovels({String? category, int limit = 20}) async {
    try {
      print('📚 Fetching novels from Gutendex...');

      Map<String, dynamic> response;

      if (category != null && category.isNotEmpty && category != 'all' && category != 'All') {
        // Fetch by topic/bookshelf
        response = await _gutendexApi.getBooksByTopic(
          category.toLowerCase().replaceAll(' ', '_'),
          limit: limit,
        );
      } else {
        // Fetch popular books
        response = await _gutendexApi.getPopularBooks(limit: limit);
      }

      if (response['results'] != null) {
        final books = response['results'] as List;
        print('✅ Found ${books.length} novels');

        final novels = <Novel>[];
        for (var book in books) {
          try {
            if (book is Map<String, dynamic>) {
              final novel = Novel.fromJson(book);
              if (novel.id.isNotEmpty && novel.title.isNotEmpty) {
                novels.add(novel);
              }
            }
          } catch (e) {
            print('⚠️ Error parsing novel: $e');
          }
        }

        return novels;
      }

      return [];
    } on TimeoutException catch (e) {
      print('❌ Timeout getting novels: $e');
      throw Exception('Connection timeout. Please check your internet connection.');
    } catch (e) {
      print('❌ Error getting novels: $e');
      throw Exception('Failed to load novels: ${e.toString()}');
    }
  }

  /// Search novel berdasarkan query
  Future<List<Novel>> searchNovels(String query, {int limit = 20}) async {
    try {
      print('🔍 Searching novels: "$query"');

      final response = await _gutendexApi.searchBooks(
        search: query,
        languages: 'en',
        copyright: 'false',
        limit: limit,
      );

      if (response['results'] != null) {
        final books = response['results'] as List;
        print('✅ Found ${books.length} results');

        final novels = <Novel>[];
        for (var book in books) {
          try {
            if (book is Map<String, dynamic>) {
              final novel = Novel.fromJson(book);
              if (novel.id.isNotEmpty && novel.title.isNotEmpty) {
                novels.add(novel);
              }
            }
          } catch (e) {
            print('⚠️ Error parsing novel: $e');
          }
        }

        return novels;
      }

      return [];
    } on TimeoutException catch (e) {
      print('❌ Timeout searching novels: $e');
      throw Exception('Connection timeout. Please check your internet connection.');
    } catch (e) {
      print('❌ Error searching novels: $e');
      throw Exception('Failed to search novels: ${e.toString()}');
    }
  }

  /// Get detail novel beserta full content
  Future<Novel?> getNovelById(String id) async {
    try {
      final bookId = int.tryParse(id);
      if (bookId == null) {
        print('❌ Invalid book ID: $id');
        return null;
      }

      print('📖 Fetching novel detail: $bookId');

      final response = await _gutendexApi.getBookDetail(bookId);

      if (response != null) {
        Novel novel = Novel.fromJson(response);

        // Download full content
        if (novel.formats != null && novel.formats!.isNotEmpty) {
          print('📥 Downloading full content...');
          final content = await _gutendexApi.downloadContent(novel.formats!);
          
          if (content != null && content.isNotEmpty) {
            print('✅ Content downloaded: ${content.length} characters');
            
            // Split content into chapters (based on common patterns)
            final chapters = _splitIntoChapters(content, novel.title);
            novel = novel.copyWith(
              content: content,
              chapters: chapters.length > 0 ? chapters.length : 1,
            );
          }
        }

        return novel;
      }

      return null;
    } catch (e) {
      print('❌ Error getting novel by id: $e');
      return null;
    }
  }

  /// Split content into chapters
  List<String> _splitIntoChapters(String content, String title) {
    final chapters = <String>[];
    
    // Pattern umum untuk chapter
    final patterns = [
      RegExp(r'CHAPTER\s+[IVXLC\d]+', multiLine: true, caseSensitive: false),
      RegExp(r'Chapter\s+\d+', multiLine: true),
      RegExp(r'^\d+\.\s', multiLine: true),
      RegExp(r'BOOK\s+[IVXLC]+', multiLine: true, caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final matches = pattern.allMatches(content).toList();
      
      if (matches.length > 1) {
        // Ada multiple chapter markers, split berdasarkan posisi
        for (int i = 0; i < matches.length; i++) {
          final start = matches[i].start;
          final end = (i < matches.length - 1) ? matches[i + 1].start : content.length;
          final chapterContent = content.substring(start, end).trim();
          
          if (chapterContent.isNotEmpty) {
            chapters.add(chapterContent);
          }
        }
        break;
      }
    }

    // Jika tidak ada chapter yang terdeteksi, anggap 1 chapter
    if (chapters.isEmpty) {
      chapters.add(content);
    }

    return chapters;
  }

  /// Get similar books (books by same author or similar subjects)
  Future<List<Novel>> getSimilarNovels(String novelId, {String? author, List<String>? subjects}) async {
    try {
      if (author != null && author.isNotEmpty) {
        // Search by author name
        return searchNovels(author, limit: 10);
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting similar novels: $e');
      return [];
    }
  }

  /// Get semua categories (bookshelves dari Project Gutenberg)
  Future<List<app_models.Category>> getAllCategories() async {
    try {
      print('📚 Fetching categories...');
      return _getDefaultCategories();
    } catch (e) {
      print('Error getting categories: $e');
      return _getDefaultCategories();
    }
  }

  /// Default categories berdasarkan Project Gutenberg Bookshelves
  List<app_models.Category> _getDefaultCategories() {
    return [
      app_models.Category(
        id: 'all',
        name: 'All',
        description: 'Semua buku',
        icon: '📚',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Children',
        name: 'Children\'s Books',
        description: 'Buku anak-anak',
        icon: '🧸',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Adventure',
        name: 'Adventure',
        description: 'Cerita petualangan',
        icon: '🗺️',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Mystery',
        name: 'Mystery',
        description: 'Cerita misteri',
        icon: '🔍',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Science Fiction',
        name: 'Science Fiction',
        description: 'Fiksi ilmiah',
        icon: '🚀',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Fantasy',
        name: 'Fantasy',
        description: 'Cerita fantasi',
        icon: '🐉',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Romance',
        name: 'Romance',
        description: 'Cerita romantis',
        icon: '💕',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Horror',
        name: 'Horror',
        description: 'Cerita horor',
        icon: '👻',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Historical',
        name: 'Historical Fiction',
        description: 'Fiksi sejarah',
        icon: '📜',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
      app_models.Category(
        id: 'Literature',
        name: 'Classic Literature',
        description: 'Sastra klasik',
        icon: '📖',
        novelCount: 0,
        createdAt: DateTime.now(),
      ),
    ];
  }

  /// Get chapters dari novel content
  Future<List<app_models.Chapter>> getChapters(String novelId, {String? title, String? author, int? chapterCount}) async {
    try {
      // Fetch novel detail untuk mendapatkan content
      final novel = await getNovelById(novelId);
      
      if (novel != null && novel.content.isNotEmpty) {
        final chapterTexts = _splitIntoChapters(novel.content, title ?? novel.title);
        
        List<app_models.Chapter> chapters = [];
        for (int i = 0; i < chapterTexts.length; i++) {
          chapters.add(app_models.Chapter(
            id: '${i + 1}',
            title: 'Chapter ${i + 1}',
            number: i + 1,
            novelId: novelId,
            content: chapterTexts[i],
            publishedAt: novel.createdAt,
            wordCount: chapterTexts[i].split(' ').length,
          ));
        }
        
        return chapters;
      }
      
      // Fallback: generate mock chapters
      return _generateMockChapters(novelId, title, author, chapterCount);
    } catch (e) {
      print('❌ Error getting chapters: $e');
      return _generateMockChapters(novelId, title, author, chapterCount);
    }
  }

  /// Get chapter detail
  Future<app_models.Chapter?> getChapterDetail(String novelId, String chapterId, {String? title, String? author}) async {
    try {
      final chapters = await getChapters(novelId, title: title, author: author);
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (e) {
      return null;
    }
  }

  /// Generate mock chapters (fallback)
  List<app_models.Chapter> _generateMockChapters(String novelId, String? title, String? author, int? chapterCount) {
    final totalChapters = chapterCount ?? 10;
    List<app_models.Chapter> chapters = [];

    for (int i = 1; i <= totalChapters; i++) {
      chapters.add(app_models.Chapter(
        id: '$i',
        title: 'Chapter $i',
        number: i,
        novelId: novelId,
        content: '[Content placeholder - Full text available via Project Gutenberg]',
        publishedAt: DateTime.now().subtract(Duration(days: totalChapters - i)),
        wordCount: 2000,
      ));
    }

    return chapters;
  }

  /// Dispose service
  void dispose() {
    _gutendexApi.dispose();
  }
}
