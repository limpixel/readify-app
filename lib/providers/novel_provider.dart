import '../models/novel.dart';
import '../models/category.dart' as app_models;
import '../models/chapter.dart' as app_models;
import '../services/novel_service.dart';
import 'novel_provider_mock.dart' show NovelProviderBase;

enum LoadState { initial, loading, loaded, error }

/// NovelProvider yang menggunakan Gutendex API (Project Gutenberg)
/// Gutendex: https://gutendex.com/
/// Provides: Metadata + FULL TEXT content (public domain books)
class NovelProvider extends NovelProviderBase {
  final NovelService _novelService;

  NovelProvider(this._novelService);

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

  // Load novels dari Gutendex (Project Gutenberg)
  @override
  Future<void> loadNovels({String? category}) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔄 loadNovels called with category: ${category ?? "null"}');
    
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      print('📚 Loading novels from Gutendex (Project Gutenberg)...');
      print('📂 Category filter: ${category ?? "none (popular books)"}');

      if (category != null && category.isNotEmpty && category != 'All' && category != 'all') {
        // Fetch by category/bookshelf
        print('📡 Calling getAllNovels with category: $category');
        final loadedNovels = await _novelService.getAllNovels(category: category, limit: 40);
        _novels = loadedNovels;
        print('📖 Loaded ${_novels.length} novels for category: $category');
        
        // Print first 3 novel titles to verify different data
        if (_novels.isNotEmpty) {
          final titlesToShow = _novels.take(3).map((n) => n.title).join(', ');
          print('📚 First 3 novels: $titlesToShow');
        }
      } else {
        // Fetch popular books
        print('📡 Calling getAllNovels (popular books)');
        final loadedNovels = await _novelService.getAllNovels(limit: 40);
        _novels = loadedNovels;
        print('📖 Loaded ${_novels.length} popular novels');
        
        // Print first 3 novel titles
        if (_novels.isNotEmpty) {
          final titlesToShow = _novels.take(3).map((n) => n.title).join(', ');
          print('📚 First 3 novels: $titlesToShow');
        }
      }

      // Update categories dengan extract dari novels yang sudah di-load
      if (_novels.isNotEmpty) {
        _categories = _novelService.extractCategoriesFromNovels(_novels);
        print('📂 Extracted ${_categories.length} categories from novels');
      } else {
        print('⚠️ No novels loaded, using default categories');
        _categories = await _novelService.getAllCategories();
      }

      print('✅ Loaded ${_novels.length} novels from Gutendex');
      print('📊 Current state: novels=${_novels.length}, categories=${_categories.length}');
      _state = LoadState.loaded;
    } catch (e) {
      print('❌ Error loading novels: $e');
      _state = LoadState.error;
      _error = e.toString();
    }

    print('🔔 Calling notifyListeners...');
    notifyListeners();
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // Load novel by ID + fetch full content
  @override
  Future<void> loadNovelById(String id) async {
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      print('📖 Loading novel by ID: $id');

      final novel = await _novelService.getNovelById(id);

      if (novel != null) {
        _selectedNovel = novel;
        print('✅ Loaded novel: ${_selectedNovel!.title}');
        if (_selectedNovel!.content.isNotEmpty) {
          print('📝 Content available: ${_selectedNovel!.content.length} chars');
        }
      } else {
        throw Exception('Novel not found');
      }

      _state = LoadState.loaded;
    } catch (e) {
      print('❌ Error loading novel: $e');
      _state = LoadState.error;
      _error = e.toString();
    }

    notifyListeners();
  }

  // Search novels di BigBookAPI
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
      print('🔍 Searching novels: $query');

      final loadedNovels = await _novelService.searchNovels(query, limit: 40);
      _novels = loadedNovels;

      print('✅ Found ${_novels.length} novels');
      _state = LoadState.loaded;
    } catch (e) {
      print('❌ Error searching novels: $e');
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
      print('📚 Loading categories...');

      // If we already have novels, extract categories from them
      if (_novels.isNotEmpty) {
        _categories = _novelService.extractCategoriesFromNovels(_novels);
      } else {
        // Otherwise, get default categories
        final loadedCategories = await _novelService.getAllCategories();
        _categories = loadedCategories;
      }

      print('✅ Loaded ${_categories.length} categories');
      _state = LoadState.loaded;
    } catch (e) {
      print('❌ Error loading categories: $e');
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

  // Get chapters dari novel
  Future<List<app_models.Chapter>> getChapters(String novelId, {String? title, String? author}) async {
    return await _novelService.getChapters(novelId, title: title, author: author);
  }
}
