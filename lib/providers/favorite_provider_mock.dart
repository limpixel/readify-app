import '../models/novel.dart';
import '../services/services.dart';
import 'favorite_provider.dart' show FavoriteProviderBase;

/// Mock Favorite Provider untuk testing dengan mock data
/// Gunakan FavoriteProvider biasa untuk API sungguhan
class FavoriteProviderMock extends FavoriteProviderBase {
  final LocalStorageService _localStorage;
  final MockDataService _mockService;

  FavoriteProviderMock(this._localStorage, this._mockService);

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

      // Fetch novel details for each favorite ID dari mock data
      for (String id in favoriteIds) {
        final novel = await _mockService.getNovelById(id);
        if (novel != null) {
          _favoriteNovels.add(novel);
        }
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
