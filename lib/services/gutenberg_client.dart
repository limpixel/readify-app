import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// Project Gutenberg API Client
/// Provides full text books (public domain)
/// API: https://gutendex.com/ (Gutenberg API wrapper)
class GutenbergClient {
  late final Dio _dio;

  GutenbergClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://gutendex.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor untuk logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📡 REQUEST[${options.method}] => ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );
  }

  // Search books
  Future<Map<String, dynamic>> searchBooks({
    String? query,
    String? author,
    String? title,
    String? subject,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      
      if (query != null && query.isNotEmpty) {
        params['search'] = query;
      }
      if (author != null && author.isNotEmpty) {
        params['author'] = author;
      }
      if (title != null && title.isNotEmpty) {
        params['title'] = title;
      }
      if (subject != null && subject.isNotEmpty) {
        params['topic'] = subject;
      }

      final response = await _dio.get('/books', queryParameters: params);
      return response.data;
    } catch (e) {
      print('Error searching books: $e');
      return {'results': []};
    }
  }

  // Get book detail by ID
  Future<Map<String, dynamic>?> getBookById(int bookId) async {
    try {
      final response = await _dio.get('/books/$bookId');
      return response.data;
    } catch (e) {
      print('Error getting book: $e');
      return null;
    }
  }

  // Get book content (text) from Gutenberg
  Future<String?> getBookContent(int bookId) async {
    try {
      // Download plain text file
      final response = await _dio.get(
        'https://www.gutenberg.org/files/$bookId/$bookId-0.txt',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data;
    } catch (e) {
      print('Error getting book content: $e');
      
      // Try alternative format
      try {
        final response = await _dio.get(
          'https://www.gutenberg.org/cache/epub/$bookId/pg$bookId.txt',
          options: Options(responseType: ResponseType.plain),
        );
        return response.data;
      } catch (e2) {
        print('Alternative content fetch failed: $e2');
        return null;
      }
    }
  }

  // Parse chapters from content
  List<Map<String, dynamic>> parseChapters(String content) {
    final chapters = <Map<String, dynamic>>[];
    
    // Split by chapter markers
    final chapterRegex = RegExp(
      r'(?:CHAPTER|Chapter|BOOK|Book)\s+(?:[IVXLC\d]+|[A-Z][a-z]+|\d+)',
      multiLine: true,
    );
    
    final matches = chapterRegex.allMatches(content);
    
    if (matches.isEmpty) {
      // No chapters found, return full content as single chapter
      chapters.add({
        'title': 'Full Content',
        'number': 1,
        'content': content,
      });
      return chapters;
    }
    
    for (var i = 0; i < matches.length; i++) {
      final start = matches.elementAt(i).start;
      final end = (i < matches.length - 1) 
          ? matches.elementAt(i + 1).start 
          : content.length;
      
      final chapterContent = content.substring(start, end).trim();
      final titleMatch = chapterRegex.firstMatch(chapterContent);
      final title = titleMatch?.group(0) ?? 'Chapter ${i + 1}';
      
      chapters.add({
        'title': title,
        'number': i + 1,
        'content': chapterContent,
      });
    }
    
    return chapters;
  }
}
