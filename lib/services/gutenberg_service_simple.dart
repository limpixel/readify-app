import 'package:dio/dio.dart';

/// Project Gutenberg Service
/// Provides FULL TEXT books (public domain)
/// Source: https://www.gutenberg.org/
class GutenbergService {
  final Dio _dio;

  GutenbergService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://www.gutenberg.org',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

  /// Get full text content of a book by Gutenberg ID
  /// Example: bookId = 84 (Pride and Prejudice)
  Future<String?> getBookContent(int bookId) async {
    try {
      print('📚 Fetching content for Gutenberg book #$bookId');
      
      // Try multiple formats
      final urls = [
        'https://www.gutenberg.org/files/$bookId/$bookId-0.txt',
        'https://www.gutenberg.org/files/$bookId/$bookId.txt',
        'https://www.gutenberg.org/cache/epub/$bookId/pg$bookId.txt',
      ];

      for (var url in urls) {
        try {
          final response = await _dio.get(
            url,
            options: Options(responseType: ResponseType.plain, followRedirects: true),
          );
          
          if (response.statusCode == 200 && response.data.isNotEmpty) {
            final content = response.data as String;
            print('✅ Got content: ${content.length} characters');
            return _cleanContent(content);
          }
        } catch (e) {
          print('⚠️ Failed to fetch from $url: $e');
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
    // Remove Gutenberg header
    final startMarker = '*** START OF';
    final startIndex = content.indexOf(startMarker);
    
    String cleaned = content;
    if (startIndex != -1) {
      final endOfLine = content.indexOf('\n', startIndex);
      if (endOfLine != -1) {
        cleaned = content.substring(endOfLine + 1);
      }
    }
    
    // Remove Gutenberg footer
    final endMarker = '*** END OF';
    final endIndex = cleaned.indexOf(endMarker);
    if (endIndex != -1) {
      cleaned = cleaned.substring(0, endIndex);
    }
    
    return cleaned.trim();
  }

  /// Search for books and return list with IDs
  Future<List<Map<String, dynamic>>> searchBooks(String query, {int limit = 20}) async {
    try {
      print('🔍 Searching Gutenberg for: $query');
      
      // Use gutendex API (Gutenberg wrapper)
      final response = await Dio().get(
        'https://gutendex.com/books',
        queryParameters: {
          'search': query,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List? ?? [];
        
        print('✅ Found ${results.length} books');
        
        return results.map((book) => {
          'id': book['id']?.toString() ?? '',
          'title': book['title']?.toString() ?? 'Unknown',
          'authors': (book['authors'] as List?)?.map((a) => a['name']).toList() ?? [],
          'subjects': book['subjects'] as List? ?? [],
        }).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error searching: $e');
      return [];
    }
  }
}
