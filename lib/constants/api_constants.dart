class ApiConstants {
  // Gutendex API - Project Gutenberg Books API
  // Documentation: https://gutendex.com/
  static const String baseUrl = 'https://gutendex.com';

  // Endpoints
  static const String books = '/books';

  // Project Gutenberg Base URL untuk content
  static const String gutenbergBaseUrl = 'https://www.gutenberg.org';

  // Timeout dalam detik
  static const int connectTimeout = 60; // Increased from 30s to 60s
  static const int receiveTimeout = 120; // Increased from 60s to 120s for download content
  static const int retryDelay = 2; // Delay between retries in seconds
  static const int maxRetries = 3; // Maximum number of retry attempts
}
