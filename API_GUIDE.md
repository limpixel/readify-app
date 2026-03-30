# 📖 Panduan Menggunakan API dengan Aplikasi E-Book Novel

## 🔄 Cara Beralih dari Mock Data ke API Sungguhan

Saat ini aplikasi menggunakan **Mock Data** untuk demonstrasi. Untuk menggunakan API sungguhan, ikuti langkah berikut:

### 1. Update File `lib/main.dart`

**Kode Saat Ini (Mock Data):**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localStorage = LocalStorageService();
  await localStorage.init();
  
  final mockService = MockDataService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NovelProviderMock(mockService),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProviderMock(localStorage, mockService),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(localStorage),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

**Ganti Dengan (API Sungguhan):**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localStorage = LocalStorageService();
  await localStorage.init();
  
  // Initialize API Client
  final apiClient = ApiClient();
  final novelService = NovelService(apiClient);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NovelProvider(novelService),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(localStorage, novelService),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(localStorage),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. Update API Configuration

Edit file `lib/constants/api_constants.dart`:

```dart
class ApiConstants {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'https://api.example.com';
  
  // Untuk Android Emulator dengan API lokal:
  // static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Untuk iOS Simulator dengan API lokal:
  // static const String baseUrl = 'http://localhost:8000';
  
  static const String novels = '/novels';
  static const String categories = '/categories';
  static const String chapters = '/chapters';
  
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
}
```

### 3. Pastikan API Endpoint Sesuai

API Anda harus memiliki endpoint berikut:

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/novels` | Mendapatkan semua novel |
| GET | `/novels?category=X` | Filter novel berdasarkan kategori |
| GET | `/novels/{id}` | Detail novel berdasarkan ID |
| GET | `/novels/search?q=judul` | Search novel |
| GET | `/categories` | Daftar semua kategori |
| GET | `/novels/{id}/chapters` | Daftar chapters novel |

### 4. Format Response API

**Response Novel (Single/List):**
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

**Response Category:**
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

**Response Chapters:**
```json
[
  {
    "id": "1",
    "title": "Chapter 1",
    "number": 1,
    "publishedAt": "2024-01-01T00:00:00Z"
  }
]
```

## 🛠️ Membuat API Sendiri

Jika belum punya API, berikut beberapa opsi:

### Opsi 1: Node.js + Express

```javascript
const express = require('express');
const app = express();
const port = 8000;

app.get('/novels', (req, res) => {
  // Return list novel dari database
  res.json([...novels]);
});

app.get('/novels/:id', (req, res) => {
  // Return novel by ID
  res.json(novel);
});

app.listen(port, () => {
  console.log(`API running at http://localhost:${port}`);
});
```

### Opsi 2: Laravel (PHP)

```php
// routes/api.php
Route::get('/novels', [NovelController::class, 'index']);
Route::get('/novels/{id}', [NovelController::class, 'show']);
Route::get('/categories', [CategoryController::class, 'index']);
```

### Opsi 3: Python + FastAPI

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/novels")
async def get_novels():
    return novels

@app.get("/novels/{novel_id}")
async def get_novel(novel_id: str):
    return novel
```

### Opsi 4: Firebase

Gunakan Firebase Firestore sebagai backend:
1. Buat collection `novels` dan `categories`
2. Gunakan Firebase REST API atau Firestore SDK
3. Update `ApiClient` untuk menggunakan Firebase endpoints

## 🔧 Troubleshooting API

### Error: Connection Timeout
- Pastikan API server berjalan
- Cek URL dan port API
- Untuk emulator Android, gunakan `10.0.2.2` bukan `localhost`

### Error: 404 Not Found
- Cek endpoint API
- Pastikan path sesuai dengan routing API Anda

### Error: CORS (untuk web)
- Tambahkan CORS middleware di API Anda
- Untuk Flutter mobile, CORS biasanya tidak menjadi masalah

### Data Tidak Muncul
- Cek response API dengan Postman/curl
- Pastikan format JSON sesuai dengan model di Flutter
- Enable logging di `ApiClient` untuk debug

## 📡 Testing API

Gunakan tools berikut untuk test API:

1. **Postman** - GUI untuk testing API
2. **curl** - Command line
   ```bash
   curl https://api.example.com/novels
   ```
3. **Insomnia** - Alternatif Postman

## 🎯 Tips

1. **Gunakan Environment Variables** untuk menyimpan URL API
2. **Implement Retry Logic** untuk network yang tidak stabil
3. **Add Loading State** untuk UX yang lebih baik
4. **Cache Response** untuk mengurangi API calls
5. **Pagination** untuk list novel yang panjang

## 📚 Resources

- [Dio Package Documentation](https://pub.dev/packages/dio)
- [Provider State Management](https://pub.dev/packages/provider)
- [Flutter Network Programming](https://flutter.dev/docs/development/data-and-backend/networking)

---

Jika ada pertanyaan, silakan buat issue di repository!
