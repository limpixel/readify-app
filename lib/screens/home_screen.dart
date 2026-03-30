import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../models/novel.dart';
import '../models/category.dart' as app_models;
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'bookmark_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final novelProvider = context.read<NovelProviderBase>();
    await novelProvider.loadNovels();
    await novelProvider.loadCategories();
    await context.read<FavoriteProviderBase>().loadFavorites();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Book Novel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const CategoryScreen(),
          const FavoriteScreen(),
          const BookmarkScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        // Category Filter
        _buildCategoryFilter(),
        // Novel Grid
        Expanded(
          child: Consumer<NovelProviderBase>(
            builder: (context, novelProvider, child) {
              if (novelProvider.isLoading) {
                return _buildLoadingGrid();
              }

              if (novelProvider.isError) {
                return _buildErrorWidget(novelProvider.error);
              }

              if (novelProvider.novels.isEmpty) {
                return _buildEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: _loadData,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.69, // Adjusted from 0.68 for extra space
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: novelProvider.novels.length,
                  itemBuilder: (context, index) {
                    final novel = novelProvider.novels[index];
                    return _buildNovelItem(novel);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<NovelProviderBase>(
      builder: (context, novelProvider, child) {
        if (novelProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              // All Category
              CategoryChip(
                category: app_models.Category(
                  id: 'all',
                  name: 'All',
                  description: 'All novels',
                  icon: '📚',
                  novelCount: 0,
                  createdAt: DateTime.now(),
                ),
                isSelected: _selectedCategory == 'All',
                onTap: () {
                  setState(() {
                    _selectedCategory = 'All';
                  });
                  context.read<NovelProvider>().loadNovels();
                },
              ),
              const SizedBox(width: 8),
              // Category List
              ...novelProvider.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    category: category,
                    isSelected: _selectedCategory == category.name,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category.name;
                      });
                      context
                          .read<NovelProvider>()
                          .getNovelsByCategory(category.name);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNovelItem(Novel novel) {
    return Consumer<FavoriteProviderBase>(
      builder: (context, favoriteProvider, child) {
        return NovelCard(
          novel: novel,
          isFavorite: favoriteProvider.isFavorite(novel.id),
          onFavoriteTap: () {
            favoriteProvider.toggleFavorite(novel);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(novel: novel),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70, // Disesuaikan dengan aspect ratio cover 2/2.8
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const NovelCardShimmer();
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada novel',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Novel akan muncul di sini',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cari Novel'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Masukkan judul novel...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Navigator.pop(context);
              context.read<NovelProviderBase>().searchNovels(value);
              setState(() {
                _selectedIndex = 0;
              });
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchController.clear();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                Navigator.pop(context);
                context.read<NovelProviderBase>().searchNovels(_searchController.text);
                setState(() {
                  _selectedIndex = 0;
                });
              }
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
