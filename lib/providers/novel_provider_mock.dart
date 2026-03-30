import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../models/novel.dart';
import '../models/category.dart' as app_models;
import '../models/chapter.dart' as app_models;
import '../services/mock_data_service.dart';
import 'novel_provider.dart' show LoadState;

/// Mock Provider untuk testing dengan mock data
/// Class ini extends NovelProviderBase untuk compatibility
class NovelProviderMock extends NovelProviderBase {
  final MockDataService _mockService;

  NovelProviderMock(this._mockService);

  List<Novel> _novels = [];
  List<app_models.Category> _categories = [];
  Novel? _selectedNovel;
  String _error = '';
  LoadState _state = LoadState.initial;

  // Getters
  @override
  List<Novel> get novels => _novels;
  @override
  List<app_models.Category> get categories => _categories;
  @override
  Novel? get selectedNovel => _selectedNovel;
  @override
  String get error => _error;
  @override
  LoadState get state => _state;

  @override
  bool get isLoading => _state == LoadState.loading;
  @override
  bool get isLoaded => _state == LoadState.loaded;
  @override
  bool get isError => _state == LoadState.error;

  // Load all novels
  @override
  Future<void> loadNovels({String? category}) async {
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      _novels = await _mockService.getNovels(category: category);
      _state = LoadState.loaded;
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
    }
    
    notifyListeners();
  }

  // Load novel by ID
  @override
  Future<void> loadNovelById(String id) async {
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      _selectedNovel = await _mockService.getNovelById(id);
      _state = LoadState.loaded;
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
    }
    
    notifyListeners();
  }

  // Search novels
  @override
  Future<void> searchNovels(String query) async {
    if (query.isEmpty) {
      await loadNovels();
      return;
    }

    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      _novels = await _mockService.searchNovels(query);
      _state = LoadState.loaded;
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
    }
    
    notifyListeners();
  }

  // Load categories
  @override
  Future<void> loadCategories() async {
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      _categories = await _mockService.getCategories();
      _state = LoadState.loaded;
    } catch (e) {
      _state = LoadState.error;
      _error = e.toString();
    }
    
    notifyListeners();
  }

  // Get novels by category
  @override
  Future<void> getNovelsByCategory(String category) async {
    await loadNovels(category: category);
  }

  // Set selected novel
  @override
  void setSelectedNovel(Novel novel) {
    _selectedNovel = novel;
    notifyListeners();
  }

  // Clear selected novel
  @override
  void clearSelectedNovel() {
    _selectedNovel = null;
    notifyListeners();
  }

  // Refresh data
  @override
  Future<void> refresh() async {
    await loadNovels();
    await loadCategories();
  }

  // Get chapters
  @override
  Future<List<app_models.Chapter>> getChapters(String novelId, {String? title, String? author}) async {
    return await _mockService.getChapters(novelId, title: title, author: author);
  }
}

/// Base class untuk NovelProvider - untuk compatibility
abstract class NovelProviderBase extends ChangeNotifier {
  List<Novel> get novels;
  List<app_models.Category> get categories;
  Novel? get selectedNovel;
  String get error;
  LoadState get state;

  bool get isLoading;
  bool get isLoaded;
  bool get isError;

  Future<void> loadNovels({String? category});
  Future<void> loadNovelById(String id);
  Future<void> searchNovels(String query);
  Future<void> loadCategories();
  Future<void> getNovelsByCategory(String category);
  void setSelectedNovel(Novel novel);
  void clearSelectedNovel();
  Future<void> refresh();
  Future<List<app_models.Chapter>> getChapters(String novelId, {String? title, String? author});
}
