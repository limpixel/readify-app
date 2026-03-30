import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../models/novel.dart';
import '../services/services.dart';

/// Base class untuk FavoriteProvider - untuk compatibility
abstract class FavoriteProviderBase extends ChangeNotifier {
  List<Novel> get favoriteNovels;
  bool get isLoading;
  String get error;
  int get favoriteCount;
  
  Future<void> loadFavorites();
  Future<void> addToFavorite(Novel novel);
  Future<void> removeFromFavorite(String novelId);
  Future<void> toggleFavorite(Novel novel);
  bool isFavorite(String novelId);
  bool isInFavoriteList(Novel novel);
  Future<void> clearAllFavorites();
  void clearError();
}

class FavoriteProvider extends FavoriteProviderBase {
  final LocalStorageService _localStorage;

  FavoriteProvider(this._localStorage);

  List<Novel> _favoriteNovels = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  @override
  List<Novel> get favoriteNovels => _favoriteNovels;
  @override
  bool get isLoading => _isLoading;
  @override
  String get error => _error;
  @override
  int get favoriteCount => _favoriteNovels.length;

  // Load favorite novels
  @override
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final favoriteIds = _localStorage.getFavoriteNovelIds();
      _favoriteNovels = [];

      // Load novel details for each favorite ID
      for (String id in favoriteIds) {
        // For now, create minimal novel objects from local storage
        // In production, you might want to fetch full details from API
      }

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }

    notifyListeners();
  }

  // Add to favorite
  @override
  Future<void> addToFavorite(Novel novel) async {
    try {
      await _localStorage.addToFavorite(novel.id);
      if (!_favoriteNovels.any((n) => n.id == novel.id)) {
        _favoriteNovels.add(novel);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Remove from favorite
  @override
  Future<void> removeFromFavorite(String novelId) async {
    try {
      await _localStorage.removeFromFavorite(novelId);
      _favoriteNovels.removeWhere((n) => n.id == novelId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Toggle favorite status
  @override
  Future<void> toggleFavorite(Novel novel) async {
    if (isFavorite(novel.id)) {
      await removeFromFavorite(novel.id);
    } else {
      await addToFavorite(novel);
    }
  }

  // Check if novel is favorite
  @override
  bool isFavorite(String novelId) {
    return _localStorage.isFavorite(novelId);
  }

  // Check if novel is in favorite list
  @override
  bool isInFavoriteList(Novel novel) {
    return _favoriteNovels.any((n) => n.id == novel.id);
  }

  // Clear all favorites
  @override
  Future<void> clearAllFavorites() async {
    try {
      await _localStorage.clearAllFavorites();
      _favoriteNovels.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Remove error
  @override
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
