# 📂 Struktur Folder Project - E-Book Novel App

## Complete File Structure

```
ebook_novel_app/
│
├── 📁 android/                          # Android platform files
├── 📁 ios/                              # iOS platform files
├── 📁 web/                              # Web platform files
├── 📁 windows/                          # Windows platform files
├── 📁 linux/                            # Linux platform files
├── 📁 macos/                            # macOS platform files
├── 📁 test/                             # Unit test files
│
├── 📁 lib/                              # Main source code directory
│   │
│   ├── 📄 main.dart                     # ⚙️ Entry point aplikasi
│   │
│   ├── 📁 constants/                    # Konstanta & konfigurasi
│   │   └── 📄 api_constants.dart        # API URL & endpoint config
│   │
│   ├── 📁 models/                       # Model data / POJO
│   │   ├── 📄 models.dart               # Export semua models
│   │   ├── 📄 novel.dart                # Model Novel
│   │   ├── 📄 category.dart             # Model Category
│   │   ├── 📄 chapter.dart              # Model Chapter
│   │   └── 📄 bookmark.dart             # Model Bookmark
│   │
│   ├── 📁 services/                     # Service layer (Business Logic)
│   │   ├── 📄 services.dart             # Export semua services
│   │   ├── 📄 api_client.dart           # HTTP Client (Dio wrapper)
│   │   ├── 📄 novel_service.dart        # API service untuk Novel
│   │   ├── 📄 local_storage_service.dart# Local storage (Hive)
│   │   └── 📄 mock_data_service.dart    # Mock data untuk testing
│   │
│   ├── 📁 providers/                    # State Management (Provider)
│   │   ├── 📄 providers.dart            # Export semua providers
│   │   ├── 📄 novel_provider.dart       # Novel state (API version)
│   │   ├── 📄 novel_provider_mock.dart  # Novel state (Mock version)
│   │   ├── 📄 favorite_provider.dart    # Favorite state (API version)
│   │   ├── 📄 favorite_provider_mock.dart# Favorite state (Mock version)
│   │   └── 📄 bookmark_provider.dart    # Bookmark state management
│   │
│   ├── 📁 screens/                      # UI Screens / Pages
│   │   ├── 📄 screens.dart              # Export semua screens
│   │   ├── 📄 home_screen.dart          # Home page (Grid novel)
│   │   ├── 📄 detail_screen.dart        # Detail novel page
│   │   ├── 📄 reading_screen.dart       # Baca novel chapter
│   │   ├── 📄 favorite_screen.dart      # List favorite novels
│   │   ├── 📄 category_screen.dart      # List categories
│   │   └── 📄 bookmark_screen.dart      # Bookmark folders
│   │
│   ├── 📁 widgets/                      # Reusable UI Components
│   │   ├── 📄 widgets.dart              # Export semua widgets
│   │   ├── 📄 novel_card.dart           # Card untuk novel item
│   │   ├── 📄 novel_card_shimmer.dart   # Loading skeleton
│   │   └── 📄 category_chip.dart        # Chip untuk category
│   │
│   └── 📁 utils/                        # Utility functions (optional)
│       └── (belum ada file)
│
├── 📄 pubspec.yaml                      # Dependencies configuration
├── 📄 pubspec.lock                      # Locked dependencies versions
├── 📄 analysis_options.yaml             # Linter rules
├── 📄 README.md                         # Project documentation
├── 📄 API_GUIDE.md                      # Panduan integrasi API
├── 📄 SETUP_COMPLETE.md                 # Setup & installation guide
├── 📄 .gitignore                        # Git ignore rules
├── 📄 .metadata                         # Flutter metadata
└── 📄 ebook_novel_app.iml               # IntelliJ/Android Studio project file
```

## 📊 File Breakdown

### Total Files: 29 Dart Files

| Directory | Files | Deskripsi |
|-----------|-------|-----------|
| `lib/models/` | 5 | Data models |
| `lib/services/` | 5 | Business logic & API |
| `lib/providers/` | 6 | State management |
| `lib/screens/` | 7 | UI screens |
| `lib/widgets/` | 4 | Reusable widgets |
| `lib/constants/` | 1 | Configuration |
| `lib/` | 1 | Main entry point |

## 🗂️ Detail Fungsi Setiap File

### 🎯 Entry Point
| File | Fungsi |
|------|--------|
| `main.dart` | Inisialisasi app, setup providers, routing utama |

### 📦 Models (`lib/models/`)
| File | Fungsi | Properties |
|------|--------|------------|
| `novel.dart` | Data novel | id, title, author, description, coverUrl, category, chapters, rating, status |
| `category.dart` | Data kategori | id, name, description, icon, novelCount |
| `chapter.dart` | Data chapter | id, title, number, content, novelId, wordCount |
| `bookmark.dart` | Data bookmark | id, name, description, novelIds |
| `models.dart` | Export file | - |

### 🔧 Services (`lib/services/`)
| File | Fungsi | Methods |
|------|--------|---------|
| `api_client.dart` | HTTP Client wrapper | get, post, put, delete |
| `novel_service.dart` | Novel API calls | getAllNovels, getNovelById, getChapters, searchNovels |
| `local_storage_service.dart` | Local DB (Hive) | CRUD favorites, bookmarks, history |
| `mock_data_service.dart` | Mock data | Mock novels, categories, chapters with content |
| `services.dart` | Export file | - |

### 📱 Providers (`lib/providers/`)
| File | Fungsi | State |
|------|--------|-------|
| `novel_provider.dart` | Novel state (API) | novels, categories, selectedNovel, loading state |
| `novel_provider_mock.dart` | Novel state (Mock) | Same as above + mock data |
| `favorite_provider.dart` | Favorite state (API) | favoriteNovels, isFavorite, toggle |
| `favorite_provider_mock.dart` | Favorite state (Mock) | Same as above + mock data |
| `bookmark_provider.dart` | Bookmark state | bookmarks, CRUD operations |
| `providers.dart` | Export file | - |

### 🖼️ Screens (`lib/screens/`)
| File | Fungsi | Features |
|------|--------|----------|
| `home_screen.dart` | Home page | Grid layout, category filter, search, bottom nav |
| `detail_screen.dart` | Novel detail | Cover, synopsis, stats, read button, bookmark |
| `reading_screen.dart` | Baca chapter | Chapter content, navigation, font settings, drawer |
| `favorite_screen.dart` | Favorite list | Grid view, remove from favorite, clear all |
| `category_screen.dart` | Categories | List categories, filter by category |
| `bookmark_screen.dart` | Bookmarks | CRUD folders, add/remove novels |
| `screens.dart` | Export file | - |

### 🧩 Widgets (`lib/widgets/`)
| File | Fungsi | Usage |
|------|--------|-------|
| `novel_card.dart` | Novel card | Display novel in grid |
| `novel_card_shimmer.dart` | Loading skeleton | While data loading |
| `category_chip.dart` | Category chip | Category filter button |
| `widgets.dart` | Export file | - |

### ⚙️ Constants (`lib/constants/`)
| File | Fungsi |
|------|--------|
| `api_constants.dart` | API base URL, endpoints, timeout config |

## 🔄 Data Flow

```
User Interaction
    ↓
Screen (UI)
    ↓
Provider (State Management)
    ↓
Service (Business Logic)
    ↓
┌─────────────────────┐
│   ApiClient         │ ← → API Server
│   LocalStorage      │ ← → Hive DB
└─────────────────────┘
```

## 📦 Dependencies (pubspec.yaml)

### Production Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  dio: ^5.4.0                        # HTTP client
  provider: ^6.1.1                   # State management
  hive: ^2.2.3                       # Local database
  hive_flutter: ^1.1.0              # Hive for Flutter
  cached_network_image: ^3.3.0      # Image caching
  shimmer: ^3.0.0                    # Loading skeleton
  flutter_staggered_grid_view: ^0.7.0  # Grid layout
  intl: ^0.18.1                      # Date formatting
  uuid: ^4.3.3                       # Generate UUID
  cupertino_icons: ^1.0.8            # Icons
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  hive_generator: ^2.0.1            # Code generator
  build_runner: ^2.4.8              # Build system
  flutter_lints: ^6.0.0             # Linting
```

## 🎨 Architecture Pattern

Project ini menggunakan **Provider Pattern** dengan struktur:

```
Presentation Layer (Screens & Widgets)
         ↓
State Management Layer (Providers)
         ↓
Business Logic Layer (Services)
         ↓
Data Layer (API & Local Storage)
```

## 📝 File Configuration

### pubspec.yaml
```yaml
name: ebook_novel_app
description: E-Book Novel Application
version: 1.0.0+1

environment:
  sdk: ^3.11.1
```

### analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml
```

## 🔑 Key Features Implementation

| Feature | Files Involved |
|---------|----------------|
| **Home** | `home_screen.dart`, `novel_card.dart`, `category_chip.dart` |
| **Detail** | `detail_screen.dart`, `novel.dart` |
| **Reading** | `reading_screen.dart`, `chapter.dart`, `novel_service.dart` |
| **Favorite** | `favorite_screen.dart`, `favorite_provider.dart`, `local_storage_service.dart` |
| **Bookmark** | `bookmark_screen.dart`, `bookmark_provider.dart`, `bookmark.dart` |
| **Category** | `category_screen.dart`, `category.dart`, `novel_provider.dart` |
| **Search** | `home_screen.dart`, `novel_service.dart` |
| **API** | `api_client.dart`, `novel_service.dart`, `api_constants.dart` |
| **Offline** | `local_storage_service.dart`, `hive` |

## 📱 Screen Navigation Flow

```
Home Screen
    ├── Detail Screen
    │       └── Reading Screen
    │
    ├── Category Screen
    │       └── Detail Screen
    │
    ├── Favorite Screen
    │       └── Detail Screen
    │
    └── Bookmark Screen
            └── Detail Screen
```

## 🚀 Quick Reference

### Add New Screen
1. Create file in `lib/screens/`
2. Export in `screens.dart`
3. Add to provider if needed
4. Add navigation in existing screen

### Add New Model
1. Create file in `lib/models/`
2. Add `fromJson` & `toJson` methods
3. Export in `models.dart`

### Add New API Endpoint
1. Add constant in `api_constants.dart`
2. Add method in corresponding service
3. Call from provider

---

**Last Updated:** March 27, 2025
**Total Lines of Code:** ~5000+ lines
**Language:** Dart / Flutter
