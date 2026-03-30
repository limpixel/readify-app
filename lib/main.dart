import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  final localStorage = LocalStorageService();
  await localStorage.init();

  // ✅ GUTENDEX API - Project Gutenberg Books (Full Text Content)
  // Documentation: https://gutendex.com/
  final novelService = NovelService();

  runApp(
    MultiProvider(
      providers: [
        // Novel Provider - menggunakan Open Library API
        ChangeNotifierProvider<NovelProviderBase>(
          create: (_) => NovelProvider(novelService),
        ),
        ChangeNotifierProvider<FavoriteProviderBase>(
          create: (_) => FavoriteProvider(localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(localStorage),
        ),
        // Novel service provider untuk reading screen
        Provider<NovelService>.value(value: novelService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Book Novel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 8,
          shadowColor: Colors.black26,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 8,
          shadowColor: Colors.black54,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
