import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';

class BookmarkProvider with ChangeNotifier {
  final LocalStorageService _localStorage;
  final Uuid _uuid = const Uuid();

  BookmarkProvider(this._localStorage);

  List<Map> _bookmarks = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Map> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get bookmarkCount => _bookmarks.length;

  // Load all bookmarks
  Future<void> loadBookmarks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _bookmarks = _localStorage.getAllBookmarks();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }

    notifyListeners();
  }

  // Create bookmark folder
  Future<void> createBookmark(String name, String description) async {
    try {
      final id = _uuid.v4();
      await _localStorage.createBookmark(id, name, description);
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update bookmark
  Future<void> updateBookmark(String id, String? name, String? description) async {
    try {
      await _localStorage.updateBookmark(id, name, description);
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete bookmark
  Future<void> deleteBookmark(String id) async {
    try {
      await _localStorage.deleteBookmark(id);
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add novel to bookmark
  Future<void> addNovelToBookmark(String bookmarkId, String novelId) async {
    try {
      await _localStorage.addNovelToBookmark(bookmarkId, novelId);
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Remove novel from bookmark
  Future<void> removeNovelFromBookmark(String bookmarkId, String novelId) async {
    try {
      await _localStorage.removeNovelFromBookmark(bookmarkId, novelId);
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get bookmark by ID
  Map? getBookmarkById(String id) {
    return _localStorage.getBookmarkById(id);
  }

  // Get bookmark novel IDs
  List<String> getBookmarkNovelIds(String bookmarkId) {
    return _localStorage.getBookmarkNovelIds(bookmarkId);
  }

  // Check if novel is in bookmark
  bool isNovelInBookmark(String bookmarkId, String novelId) {
    final novelIds = getBookmarkNovelIds(bookmarkId);
    return novelIds.contains(novelId);
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    try {
      await _localStorage.clearAllBookmarks();
      _bookmarks.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Remove error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
