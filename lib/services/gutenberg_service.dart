import 'package:dio/dio.dart';

/// Project Gutenberg Service - Direct Download
/// Provides FULL TEXT books from Project Gutenberg
/// Source: https://www.gutenberg.org/
/// 
/// Direct URL Pattern:
/// - https://www.gutenberg.org/files/{book_id}/{book_id}.txt
/// - https://www.gutenberg.org/files/{book_id}/{book_id}-0.txt
/// - https://www.gutenberg.org/cache/epub/{book_id}/pg{book_id}.txt
class GutenbergService {
  final Dio _dio;
  final Dio _textDio;

  GutenbergService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://gutendex.com',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ),
        _textDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            responseType: ResponseType.plain,
          ),
        );

  /// Get full text content of a book by Gutenberg ID
  /// Example: bookId = 84 (Pride and Prejudice)
  /// 
  /// Direct URLs (no API key needed):
  /// - https://www.gutenberg.org/files/{id}/{id}.txt
  /// - https://www.gutenberg.org/files/{id}/{id}-0.txt
  /// - https://www.gutenberg.org/cache/epub/{id}/pg{id}.txt
  Future<String?> getBookContent(int bookId) async {
    try {
      print('📚 Fetching content for Gutenberg book #$bookId');
      
      // Try multiple URL patterns (fallback chain)
      final urls = [
        'https://www.gutenberg.org/files/$bookId/$bookId-0.txt',
        'https://www.gutenberg.org/files/$bookId/$bookId.txt',
        'https://www.gutenberg.org/cache/epub/$bookId/pg$bookId.txt',
        'https://www.gutenberg.org/files/$bookId/$bookId-8.txt',
        'https://www.gutenberg.org/files/$bookId/$bookId-9.txt',
      ];

      for (var url in urls) {
        try {
          print('🔗 Trying: $url');
          final response = await _textDio.get(
            url,
            options: Options(
              followRedirects: true,
              maxRedirects: 5,
            ),
          );
          
          if (response.statusCode == 200 && response.data != null && response.data.toString().isNotEmpty) {
            final content = response.data as String;
            print('✅ Got content from $url: ${content.length} characters');
            return _cleanContent(content);
          }
        } catch (e) {
          print('⚠️ Failed: $url - $e');
          continue;
        }
      }
      
      print('❌ All URLs failed for book #$bookId');
      return null;
    } catch (e) {
      print('❌ Error getting book content: $e');
      return null;
    }
  }

  /// Clean Gutenberg content (remove header/footer)
  String _cleanContent(String content) {
    if (content.isEmpty) return '';
    
    String cleaned = content;
    
    // Remove Gutenberg header
    // Pattern: "*** START OF" or "***START OF"
    final startPatterns = [
      '*** START OF',
      '***START OF',
      '** START OF',
      '*** START OF THE PROJECT GUTENBERG',
      '*** START OF THIS PROJECT GUTENBERG',
    ];
    
    for (var pattern in startPatterns) {
      final startIndex = cleaned.indexOf(pattern);
      if (startIndex != -1) {
        // Find the end of the header line
        final endOfLine = cleaned.indexOf('\n', startIndex);
        if (endOfLine != -1) {
          cleaned = cleaned.substring(endOfLine + 1);
          break;
        }
      }
    }
    
    // Remove Gutenberg footer
    // Pattern: "*** END OF" or "***END OF"
    final endPatterns = [
      '*** END OF',
      '***END OF',
      '** END OF',
      '*** END OF THIS PROJECT GUTENBERG',
      '*** END OF THE PROJECT GUTENBERG',
    ];
    
    for (var pattern in endPatterns) {
      final endIndex = cleaned.indexOf(pattern);
      if (endIndex != -1) {
        cleaned = cleaned.substring(0, endIndex);
        break;
      }
    }
    
    // Clean up extra whitespace
    cleaned = cleaned.trim();
    
    // Remove any remaining Project Gutenberg headers/footers
    cleaned = cleaned.replaceAll(RegExp(r'^The Project Gutenberg.*$', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^Copyright.*$', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^License.*$', multiLine: true), '');
    
    print('📝 Cleaned content: ${cleaned.length} characters');
    return cleaned;
  }

  /// Search for books using Gutendex API (metadata only)
  /// Returns list of books with their Gutenberg IDs
  Future<List<Map<String, dynamic>>> searchBooks(String query, {int limit = 20}) async {
    try {
      print('🔍 Searching Gutenberg for: "$query"');
      
      final response = await _dio.get(
        '/books',
        queryParameters: {
          'search': query,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List? ?? [];
        
        print('✅ Found ${results.length} books');
        
        return results.map((book) => _parseBookMetadata(book)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error searching: $e');
      return [];
    }
  }

  /// Get books by topic/subject
  Future<List<Map<String, dynamic>>> getBooksByTopic(String topic, {int limit = 20}) async {
    try {
      print('📚 Getting books by topic: "$topic"');
      
      final response = await _dio.get(
        '/books',
        queryParameters: {
          'topic': topic,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List? ?? [];
        
        print('✅ Found ${results.length} books for topic: $topic');
        
        return results.map((book) => _parseBookMetadata(book)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting books by topic: $e');
      return [];
    }
  }

  /// Get popular books
  Future<List<Map<String, dynamic>>> getPopularBooks({int limit = 20}) async {
    try {
      print('📚 Getting popular books');
      
      final response = await _dio.get(
        '/books',
        queryParameters: {
          'sort': 'popular',
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List? ?? [];
        
        print('✅ Found ${results.length} popular books');
        
        return results.map((book) => _parseBookMetadata(book)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting popular books: $e');
      return [];
    }
  }

  /// Parse book metadata from Gutendex response
  Map<String, dynamic> _parseBookMetadata(Map<String, dynamic> book) {
    final id = book['id']?.toString() ?? '';
    final title = book['title']?.toString() ?? 'Unknown';
    final authors = book['authors'] as List? ?? [];
    
    List<String> authorNames = [];
    for (var author in authors) {
      if (author is Map && author['name'] != null) {
        authorNames.add(author['name'].toString());
      }
    }
    
    final subjects = book['subjects'] as List? ?? [];
    final languages = book['languages'] as List? ?? [];
    final formats = book['formats'] as Map? ?? {};
    
    // Get text format URL
    String? textUrl;
    for (var key in formats.keys) {
      if (key.toString().contains('text/html') || key.toString().contains('text/plain')) {
        textUrl = formats[key]?.toString();
        break;
      }
    }
    
    return {
      'id': id,
      'title': title,
      'authors': authorNames,
      'subjects': subjects,
      'languages': languages,
      'formats': formats,
      'text_url': textUrl,
      'download_count': book['download_count'] ?? 0,
    };
  }

  /// Get book detail by Gutenberg ID
  Future<Map<String, dynamic>?> getBookDetail(int bookId) async {
    try {
      print('📖 Getting detail for book #$bookId');
      
      final response = await _dio.get('/books/$bookId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        return _parseBookMetadata(data);
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting book detail: $e');
      return null;
    }
  }
}
