class ApiConstants {
  // Gutendex API - Project Gutenberg Books API
  // Documentation: https://gutendex.com/
  static const String baseUrl = 'https://gutendex.com';

  // Endpoints
  static const String books = '/books';

  // Project Gutenberg Base URL untuk content
  static const String gutenbergBaseUrl = 'https://www.gutenberg.org';

  // Timeout dalam detik
  static const int connectTimeout = 30;
  static const int receiveTimeout = 60; // Lebih lama untuk download content
}
