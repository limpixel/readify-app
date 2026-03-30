import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _favoriteBoxName = 'favorites';
  static const String _bookmarkBoxName = 'bookmarks';
  static const String _historyBoxName = 'reading_history';

  late Box<String> _favoriteBox;
  late Box<Map> _bookmarkBox;
  late Box<Map> _historyBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    _favoriteBox = await Hive.openBox<String>(_favoriteBoxName);
    _bookmarkBox = await Hive.openBox<Map>(_bookmarkBoxName);
    _historyBox = await Hive.openBox<Map>(_historyBoxName);
  }

  // ==================== FAVORITE ====================
  
  // Add to favorite
  Future<void> addToFavorite(String novelId) async {
    await _favoriteBox.put(novelId, novelId);
  }

  // Remove from favorite
  Future<void> removeFromFavorite(String novelId) async {
    await _favoriteBox.delete(novelId);
  }

  // Check if novel is favorite
  bool isFavorite(String novelId) {
    return _favoriteBox.containsKey(novelId);
  }

  // Get all favorite novel IDs
  List<String> getFavoriteNovelIds() {
    return _favoriteBox.values.toList();
  }

  // Get favorite count
  int getFavoriteCount() {
    return _favoriteBox.length;
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _favoriteBox.clear();
  }

  // ==================== BOOKMARK ====================

  // Create bookmark folder
  Future<void> createBookmark(String id, String name, String description) async {
    await _bookmarkBox.put(id, {
      'id': id,
      'name': name,
      'description': description,
      'novelIds': [],
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Update bookmark
  Future<void> updateBookmark(String id, String? name, String? description) async {
    final bookmark = _bookmarkBox.get(id);
    if (bookmark != null) {
      await _bookmarkBox.put(id, {
        ...bookmark,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Delete bookmark
  Future<void> deleteBookmark(String id) async {
    await _bookmarkBox.delete(id);
  }

  // Add novel to bookmark
  Future<void> addNovelToBookmark(String bookmarkId, String novelId) async {
    final bookmark = _bookmarkBox.get(bookmarkId);
    if (bookmark != null) {
      List<String> novelIds = List<String>.from(bookmark['novelIds'] ?? []);
      if (!novelIds.contains(novelId)) {
        novelIds.add(novelId);
        await _bookmarkBox.put(bookmarkId, {
          ...bookmark,
          'novelIds': novelIds,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  // Remove novel from bookmark
  Future<void> removeNovelFromBookmark(String bookmarkId, String novelId) async {
    final bookmark = _bookmarkBox.get(bookmarkId);
    if (bookmark != null) {
      List<String> novelIds = List<String>.from(bookmark['novelIds'] ?? []);
      novelIds.remove(novelId);
      await _bookmarkBox.put(bookmarkId, {
        ...bookmark,
        'novelIds': novelIds,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Get all bookmarks
  List<Map> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  // Get bookmark by ID
  Map? getBookmarkById(String id) {
    return _bookmarkBox.get(id);
  }

  // Check if bookmark exists
  bool bookmarkExists(String id) {
    return _bookmarkBox.containsKey(id);
  }

  // Get bookmark novel IDs
  List<String> getBookmarkNovelIds(String bookmarkId) {
    final bookmark = _bookmarkBox.get(bookmarkId);
    if (bookmark != null) {
      return List<String>.from(bookmark['novelIds'] ?? []);
    }
    return [];
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }

  // ==================== READING HISTORY ====================

  // Add to reading history
  Future<void> addToHistory(String novelId, int chapterIndex) async {
    await _historyBox.put(novelId, {
      'novelId': novelId,
      'chapterIndex': chapterIndex,
      'lastReadAt': DateTime.now().toIso8601String(),
    });
  }

  // Get reading history
  List<Map> getReadingHistory() {
    return _historyBox.values.toList();
  }

  // Remove from history
  Future<void> removeFromHistory(String novelId) async {
    await _historyBox.delete(novelId);
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    await _historyBox.clear();
  }

  // Close boxes
  Future<void> close() async {
    await _favoriteBox.close();
    await _bookmarkBox.close();
    await _historyBox.close();
  }
}
