# 📚 Open Library API Integration Guide

## API yang Digunakan

Aplikasi ini sekarang menggunakan **Open Library API** - API gratis dan open source dari Internet Archive.

### 🔗 Dokumentasi Resmi
- Website: https://openlibrary.org
- API Docs: https://openlibrary.org/developers/api
- GitHub: https://github.com/internetarchive/openlibrary

### ✅ Keuntungan Menggunakan Open Library

| Fitur | Keterangan |
|-------|-----------|
| **Gratis** | 100% gratis, tidak perlu API key |
| **Koleksi Besar** | Jutaan buku/ebook tersedia |
| **Cover Images** | Tersedia dalam 3 ukuran (S, M, L) |
| **No Rate Limit** | Tidak ada batasan request untuk penggunaan normal |
| **Stabil** | Dikelola oleh Internet Archive (non-profit) |
| **Open Source** | Code terbuka dan komunitas aktif |

---

## 📡 Endpoint yang Digunakan

### 1. Search Books (Main Endpoint)
```
GET https://openlibrary.org/search.json
```

**Parameters:**
- `q`: Query pencarian (judul, author, subject)
- `limit`: Jumlah hasil (max 100)
- `fields`: Field yang diambil (menghemat bandwidth)

**Contoh Request:**
```
https://openlibrary.org/search.json?q=subject:fiction&limit=40&fields=key,title,author_name,cover_i,first_publish_year,rating_average,subject
```

**Response Format:**
```json
{
  "numFound": 12345,
  "start": 0,
  "docs": [
    {
      "key": "/works/OL12345W",
      "title": "Book Title",
      "author_name": ["Author Name"],
      "cover_i": 123456,
      "first_publish_year": 2020,
      "rating_average": 4.5,
      "subject": ["Fiction", "Adventure"]
    }
  ]
}
```

### 2. Get Work Detail
```
GET https://openlibrary.org/works/{OL_ID}.json
```

**Contoh:**
```
https://openlibrary.org/works/OL12345W.json
```

### 3. Get Subjects (Categories)
```
GET https://openlibrary.org/subjects/{subject}.json
```

**Contoh:**
```
https://openlibrary.org/subjects/fiction.json
```

---

## 🖼️ Cover Images

Open Library menyediakan cover images dalam 3 ukuran:

| Ukuran | Code | Dimension |
|--------|------|-----------|
| Small | `S` | ~100px |
| Medium | `M` | ~200px |
| Large | `L` | ~400px |

### Format URL Cover

**Menggunakan Cover ID:**
```
https://covers.openlibrary.org/b/id/{cover_id}-{size}.jpg
```
Contoh: `https://covers.openlibrary.org/b/id/123456-L.jpg`

**Menggunakan OLID:**
```
https://covers.openlibrary.org/b/olid/{olid}-{size}.jpg
```
Contoh: `https://covers.openlibrary.org/b/olid/OL12345W-L.jpg`

---

## 📝 Mapping Data ke Model Novel

```dart
// Open Library Response → Novel Model
Novel(
  id: json['key'],              // "/works/OL12345W"
  title: json['title'],         // "Book Title"
  author: json['author_name'],  // ["Author Name"]
  coverUrl: generateCoverUrl(json['cover_i']),
  category: json['subject']?.first ?? 'Fiction',
  rating: json['rating_average'] ?? 0,
  createdAt: DateTime(json['first_publish_year']),
)
```

---

## 🛠️ Konfigurasi di Project

### 1. API Constants (`lib/constants/api_constants.dart`)
```dart
class ApiConstants {
  static const String baseUrl = 'https://openlibrary.org';
  static const String search = '/search.json';
  static const String subjects = '/subjects';
  static const String coverBaseUrl = 'https://covers.openlibrary.org/b';
  static const String coverSize = 'L'; // Large size
}
```

### 2. Initialize di `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localStorage = LocalStorageService();
  await localStorage.init();
  
  // Initialize API Client dan Novel Service
  final apiClient = ApiClient();
  final novelService = NovelService(apiClient);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NovelProviderBase>(
          create: (_) => NovelProvider(novelService),
        ),
        // ... providers lainnya
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## 🔍 Query Examples

### Get Fiction Novels
```
/search.json?q=subject:fiction&limit=40
```

### Get Fantasy Novels
```
/search.json?q=subject:fantasy&limit=40
```

### Search by Title
```
/search.json?q=title:dragon&limit=40
```

### Search by Author
```
/search.json?q=author:rowling&limit=40
```

### Get Romance Novels
```
/search.json?q=subject:romance&limit=40
```

---

## ⚠️ Limitations & Workarounds

### 1. Tidak Ada Chapter Content
**Problem:** Open Library hanya menyediakan metadata, bukan isi buku.

**Solution:** 
- Tampilkan metadata (title, author, cover)
- Link ke Open Library untuk baca full book
- Atau gunakan API lain untuk chapter content

### 2. Rating Tidak Selalu Ada
**Problem:** Tidak semua buku memiliki rating.

**Solution:** 
- Default rating = 0
- Tampilkan "No rating" jika rating = 0

### 3. Cover Tidak Selalu Ada
**Problem:** Tidak semua buku memiliki cover image.

**Solution:** 
- Fallback ke placeholder image
- Tampilkan "No Cover" dengan icon buku

---

## 🧪 Testing

### Test API Langsung

```bash
# Test search endpoint
curl "https://openlibrary.org/search.json?q=subject:fiction&limit=5"

# Test specific work
curl "https://openlibrary.org/works/OL12345W.json"

# Test cover image
curl "https://covers.openlibrary.org/b/id/123456-L.jpg"
```

### Test di Aplikasi

1. Run aplikasi: `flutter run`
2. Check console untuk log API request
3. Pull-to-refresh di home screen untuk reload data

---

## 📊 Performance Tips

1. **Cache Images**: Menggunakan `cached_network_image` package
2. **Limit Fields**: Hanya request field yang diperlukan
3. **Pagination**: Load data secara bertahap (40 items per request)
4. **Error Handling**: Fallback ke placeholder jika API gagal

---

## 🔐 Authentication

**Tidak diperlukan!** Open Library API adalah public API dan tidak memerlukan authentication.

---

## 📞 Support & Community

- Stack Overflow: Tag `openlibrary`
- GitHub Issues: https://github.com/internetarchive/openlibrary/issues
- Forum: https://forum.openlibrary.org/

---

## 📄 License

Open Library API menggunakan **CC0 License** (Public Domain)
- Data dapat digunakan untuk tujuan komersial dan non-komersial
- Attribution appreciated tapi tidak required

---

**Last Updated:** March 27, 2026
