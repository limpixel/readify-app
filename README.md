# E-Book Novel App - Flutter

Aplikasi e-book novel dengan Flutter yang memiliki fitur CRUD untuk favorite dan bookmark/category.

## 📱 Fitur Utama

### ✅ Fitur yang Sudah Diimplementasi
1. **Home Screen** - Menampilkan daftar novel dengan grid layout
2. **Category Filter** - Filter novel berdasarkan kategori
3. **Search** - Pencarian novel berdasarkan judul
4. **Detail Screen** - Detail novel dengan synopsis, rating, chapters
5. **Favorite System** - CRUD untuk menambahkan novel ke favorite
6. **Bookmark Folder** - CRUD untuk membuat folder bookmark dan mengelompokkan novel
7. **Category Screen** - List semua kategori novel
8. **Offline Storage** - Data favorite dan bookmark tersimpan lokal menggunakan Hive
9. **Modern UI** - Material Design 3 dengan dark mode support
10. **Image Caching** - Cached network image untuk performa optimal

## 🛠️ Tech Stack

- **Flutter** - Framework UI
- **Provider** - State Management
- **Dio** - HTTP Client untuk API calls
- **Hive** - Local database untuk penyimpanan offline
- **Cached Network Image** - Image caching
- **Shimmer** - Loading skeleton
- **UUID** - Generate unique IDs

## 📦 Instalasi

### Prerequisites
1. **Flutter SDK** (versi 3.11.1 atau lebih baru)
   - Download di: https://flutter.dev/docs/get-started/install
   
2. **Android Studio / VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

3. **Android SDK / Xcode** (untuk iOS)
   - Android: Install via Android Studio
   - iOS: Xcode (hanya untuk macOS)

### Langkah Instalasi

```bash
# 1. Clone atau download project ini
cd /path/to/ebook_novel_app

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run

# 4. (Opsional) Build APK
flutter build apk --release

# 5. (Opsional) Build untuk iOS
flutter build ios
```

## 🔧 Konfigurasi API

File konfigurasi API ada di `lib/constants/api_constants.dart`:

```dart
class ApiConstants {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'https://api.example.com';
  
  // Atau gunakan API lokal
  // Android emulator: static const String baseUrl = 'http://10.0.2.2:8000';
  // iOS simulator: static const String baseUrl = 'http://localhost:8000';
}
```

### API Endpoints yang Dibutuhkan

```
GET /novels              - Mendapatkan semua novel
GET /novels/{id}         - Mendapatkan detail novel by ID
GET /novels?category=X   - Filter novel by kategori
GET /novels/search?q=X   - Search novel
GET /categories          - Mendapatkan semua kategori
GET /novels/{id}/chapters - Mendapatkan chapters novel
```

### Format Response API

**Novel:**
```json
{
  "id": "1",
  "title": "Judul Novel",
  "author": "Nama Author",
  "description": "Sinopsis novel...",
  "cover": "https://example.com/cover.jpg",
  "category": "Fantasy",
  "chapters": 100,
  "rating": 4.5,
  "status": "ongoing",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-15T00:00:00Z"
}
```

**Category:**
```json
{
  "id": "1",
  "name": "Fantasy",
  "description": "Novel fantasy",
  "icon": "🐉",
  "novel_count": 50,
  "created_at": "2024-01-01T00:00:00Z"
}
```

## 📂 Struktur Folder

```
lib/
├── constants/          # Konstanta aplikasi (API config, dll)
├── models/             # Model data (Novel, Category, Bookmark)
├── services/           # Service layer (API client, Local storage)
├── providers/          # State management (Provider)
├── screens/            # UI Screens (Home, Detail, Favorite, dll)
├── widgets/            # Reusable widgets (Card, Chip, dll)
└── main.dart           # Entry point aplikasi
```

## 🎨 Fitur UI

### Material Design 3
- Color scheme yang modern dengan Indigo sebagai primary color
- Support dark mode otomatis mengikuti system
- Card dengan elevation dan shadow
- Bottom navigation bar yang smooth

### Responsive Layout
- Grid layout 2 kolom untuk novel list
- Adaptive untuk berbagai ukuran layar
- Loading state dengan shimmer effect
- Empty state yang informatif

## 🔐 Penyimpanan Lokal

Data disimpan menggunakan **Hive** (NoSQL local database):

- **Favorites** - Novel yang difavoritkan
- **Bookmarks** - Folder bookmark dengan novel di dalamnya
- **Reading History** - Riwayat membaca (untuk pengembangan selanjutnya)

## 🚀 Cara Menggunakan

### Menambahkan Novel ke Favorite
1. Buka halaman Home atau Detail
2. Tap icon heart (❤️) pada novel
3. Novel akan tersimpan di tab Favorites

### Membuat Bookmark Folder
1. Buka tab Bookmarks
2. Tap tombol "+" di pojok kanan atas
3. Masukkan nama dan deskripsi bookmark
4. Folder bookmark akan dibuat

### Menambahkan Novel ke Bookmark
1. Buka detail novel
2. Tap tombol bookmark
3. Pilih folder bookmark yang tersedia
4. Atau buat folder baru langsung dari dialog

### Mengelola Kategori
1. Buka tab Categories
2. Tap kategori untuk filter novel
3. Novel dalam kategori akan muncul di bottom sheet

## 🧪 Testing

```bash
# Run tests
flutter test

# Run dengan profile mode
flutter run --profile

# Build untuk testing
flutter build apk --debug
```

## 📱 Screenshots

| Home | Detail | Favorites | Bookmarks |
|------|--------|-----------|-----------|
| ![Home](screenshots/home.png) | ![Detail](screenshots/detail.png) | ![Favorite](screenshots/favorite.png) | ![Bookmark](screenshots/bookmark.png) |

## 🤝 Kontribusi

1. Fork project ini
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📝 License

Project ini dilisensikan di bawah MIT License.

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter

---

## ⚠️ Catatan Penting

1. **Tailwind CSS**: Tailwind CSS tidak dapat digunakan langsung di Flutter karena Tailwind adalah utility-first CSS framework untuk web. Sebagai gantinya, aplikasi ini menggunakan Material Design 3 yang merupakan design system modern dari Google.

2. **API Integration**: Aplikasi ini siap terintegrasi dengan API E-Book apapun yang mengikuti format response yang sudah ditentukan. Jika tidak ada API, Anda bisa:
   - Menggunakan mock data untuk development
   - Membuat API sendiri menggunakan Node.js, Laravel, Django, dll
   - Menggunakan public API seperti NovelUpdates API (jika tersedia)

3. **Platform Support**: 
   - ✅ Android
   - ✅ iOS
   - ✅ Web (dengan beberapa penyesuaian)
   - 🔄 Desktop (Windows, macOS, Linux - memerlukan testing tambahan)

## 🆘 Troubleshooting

### Error: "No devices found"
```bash
# Untuk Android
flutter devices
adb devices

# Untuk iOS
flutter devices
```

### Error: "Package not found"
```bash
flutter clean
flutter pub get
```

### Error: "Build failed"
```bash
# Android
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
flutter run

# iOS
cd ios && pod install && cd ..
flutter clean
flutter pub get
flutter run
```

## 📞 Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini.
