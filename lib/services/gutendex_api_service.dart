import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Service untuk Gutendex API (Project Gutenberg)
/// Dokumentasi: https://gutendex.com/
/// Provides: Metadata buku + Full text content (public domain)
class GutendexApiService {
  final http.Client _client;

  GutendexApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Helper method untuk retry logic
  Future<T> _retryWithDelay<T>(Future<T> Function() operation, {String operationName = 'Operation'}) async {
    int lastErrorStatusCode = 0;
    
    for (int attempt = 0; attempt < ApiConstants.maxRetries; attempt++) {
      try {
        print('📡 $operationName (attempt ${attempt + 1}/${ApiConstants.maxRetries})');
        return await operation();
      } on TimeoutException catch (e) {
        print('⏰ Timeout on attempt ${attempt + 1}: $e');
        if (attempt < ApiConstants.maxRetries - 1) {
          print('⏳ Retrying in ${ApiConstants.retryDelay} seconds...');
          await Future.delayed(Duration(seconds: ApiConstants.retryDelay));
        }
      } on http.ClientException catch (e) {
        print('🌐 ClientException on attempt ${attempt + 1}: $e');
        if (attempt < ApiConstants.maxRetries - 1) {
          print('⏳ Retrying in ${ApiConstants.retryDelay} seconds...');
          await Future.delayed(Duration(seconds: ApiConstants.retryDelay));
        }
      } catch (e) {
        if (e is http.Response) {
          lastErrorStatusCode = e.statusCode;
        }
        print('❌ Error on attempt ${attempt + 1}: $e');
        if (attempt < ApiConstants.maxRetries - 1) {
          print('⏳ Retrying in ${ApiConstants.retryDelay} seconds...');
          await Future.delayed(Duration(seconds: ApiConstants.retryDelay));
        }
      }
    }
    
    throw Exception('$operationName failed after ${ApiConstants.maxRetries} attempts');
  }

  /// Search books dengan query
  ///
  /// Parameters:
  /// - search: Kata kunci pencarian (judul/penulis)
  /// - languages: Filter bahasa (default: 'en')
  /// - copyright: Filter copyright status ('false' untuk public domain)
  /// - topic: Filter by bookshelf/topic
  /// - limit: Max results (default: 20)
  Future<Map<String, dynamic>> searchBooks({
    String? search,
    String? languages = 'en',
    String? copyright = 'false',
    String? topic,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, String>{};

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      if (languages != null) {
        queryParameters['languages'] = languages;
      }

      if (copyright != null) {
        queryParameters['copyright'] = copyright;
      }

      if (topic != null && topic.isNotEmpty) {
        queryParameters['topic'] = topic;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}')
          .replace(queryParameters: queryParameters);

      print('📚 Gutendex Search: $uri');

      return await _retryWithDelay(() async {
        final response = await _client.get(uri).timeout(
          Duration(seconds: ApiConstants.connectTimeout),
        );

        print('📖 Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          print('❌ Error: ${response.statusCode} - ${response.body}');
          throw Exception('API error: ${response.statusCode}');
        }
      }, operationName: 'Gutendex Search');
    } catch (e) {
      print('❌ Gutendex search error: $e');
      rethrow;
    }
  }

  /// Get detail buku berdasarkan ID
  Future<Map<String, dynamic>> getBookDetail(int bookId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/books/$bookId');

      print('📖 Gutendex Book Detail: $uri');

      return await _retryWithDelay(() async {
        final response = await _client.get(uri).timeout(
          Duration(seconds: ApiConstants.connectTimeout),
        );

        print('📖 Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('API error: ${response.statusCode}');
        }
      }, operationName: 'Gutendex Book Detail');
    } catch (e) {
      print('❌ Gutendex book detail error: $e');
      rethrow;
    }
  }

  /// Download full text content dari Project Gutenberg
  ///
  /// Parameters:
  /// - formats: Map dari format URLs (dari book detail)
  /// - preferredFormat: Format yang diprioritaskan (default: text/plain)
  Future<String?> downloadContent(Map<String, dynamic> formats, {String preferredFormat = 'text/plain'}) async {
    try {
      // Cari URL untuk text/plain terlebih dahulu
      String? contentUrl;

      // Priority 1: text/plain
      final plainTextKey = formats.keys.firstWhere(
        (key) => key.startsWith('text/plain'),
        orElse: () => '',
      );

      if (plainTextKey.isNotEmpty) {
        contentUrl = formats[plainTextKey];
      } else {
        // Priority 2: text/html
        final htmlKey = formats.keys.firstWhere(
          (key) => key.startsWith('text/html'),
          orElse: () => '',
        );

        if (htmlKey.isNotEmpty) {
          contentUrl = formats[htmlKey];
        }
      }

      if (contentUrl == null || contentUrl.isEmpty) {
        print('⚠️ No text content available');
        return null;
      }

      print('📥 Downloading content from: $contentUrl');

      return await _retryWithDelay(() async {
        final response = await _client.get(Uri.parse(contentUrl!)).timeout(
          Duration(seconds: ApiConstants.receiveTimeout),
        );

        if (response.statusCode == 200) {
          // Jika HTML, extract text content
          if (contentUrl!.contains('.htm')) {
            return _extractTextFromHtml(response.body);
          }
          return response.body;
        } else {
          print('❌ Failed to download content: ${response.statusCode}');
          throw Exception('Download failed: ${response.statusCode}');
        }
      }, operationName: 'Content Download');
    } catch (e) {
      print('❌ Content download error: $e');
      return null;
    }
  }

  /// Extract text dari HTML (sederhana)
  String _extractTextFromHtml(String html) {
    // Remove HTML tags
    String text = html.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Decode HTML entities
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    
    // Remove extra whitespace
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    
    return text.trim();
  }

  /// Get popular books (sorted by popularity)
  Future<Map<String, dynamic>> getPopularBooks({int limit = 20}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}')
          .replace(queryParameters: {
        'sort': 'popular',
        'languages': 'en',
      });

      print('📚 Gutendex Popular Books: $uri');

      return await _retryWithDelay(() async {
        final response = await _client.get(uri).timeout(
          Duration(seconds: ApiConstants.connectTimeout),
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('API error: ${response.statusCode}');
        }
      }, operationName: 'Gutendex Popular Books');
    } catch (e) {
      print('❌ Gutendex popular books error: $e');
      rethrow;
    }
  }

  /// Get books by topic/bookshelf
  Future<Map<String, dynamic>> getBooksByTopic(String topic, {int limit = 20}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}')
          .replace(queryParameters: {
        'topic': topic,
        'languages': 'en',
        'copyright': 'false',
        'limit': limit.toString(),
      });

      print('📚 Gutendex Topic [$topic]: $uri');
      print('🔍 Topic parameter value: "$topic"');

      return await _retryWithDelay(() async {
        final response = await _client.get(uri).timeout(
          Duration(seconds: ApiConstants.connectTimeout),
        );

        print('📡 API Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final results = data['results'] as List? ?? [];
          print('✅ Got ${results.length} books for topic: $topic');
          return data;
        } else {
          print('❌ API error: ${response.statusCode} - ${response.body}');
          throw Exception('API error: ${response.statusCode}');
        }
      }, operationName: 'Gutendex Topic');
    } catch (e) {
      print('❌ Gutendex topic error: $e');
      rethrow;
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
