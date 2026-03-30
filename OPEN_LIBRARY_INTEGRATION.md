# 📚 Open Library API Integration

## ✅ Implementasi Selesai

Aplikasi sekarang menggunakan **Open Library API** - API gratis dan open source dari Internet Archive.

### 🔗 Dokumentasi Resmi
- Website: https://openlibrary.org
- API Docs: https://openlibrary.org/developers/api
- GitHub: https://github.com/internetarchive/openlibrary

---

## 🚀 Perubahan yang Dilakukan

### 1. Main App (`lib/main.dart`)
```dart
final apiClient = ApiClient();
final novelService = NovelService(apiClient);

// Provider menggunakan NovelService dengan Open Library API
ChangeNotifierProvider<NovelProviderBase>(
  create: (_) => NovelProvider(novelService),
),
```

### 2. Novel Service (`lib/services/novel_service.dart`)
- ✅ Fetch data dari Open Library Search API
- ✅ Support pencarian berdasarkan kategori
- ✅ Support pencarian novel by title/author
- ✅ Error handling yang lebih baik
- ✅ Logging untuk debugging

### 3. Novel Model (`lib/models/novel.dart`)
- ✅ Mapping data dari Open Library API response
- ✅ Generate cover URL dari cover_id
- ✅ Handle author_name (List atau Map)
- ✅ Parse rating dan tahun publikasi

### 4. Novel Provider (`lib/providers/novel_provider.dart`)
- ✅ Menggunakan NovelService (Open Library)
- ✅ Load novels, categories, search
- ✅ State management yang proper

### 5. Reading Screen (`lib/screens/reading_screen.dart`)
- ✅ Handle kasus tidak ada chapter content
- ✅ Tampilkan info novel jika chapter tidak tersedia

---

## 📡 Endpoint Open Library yang Digunakan

### 1. Search Books (Main Endpoint)
```
GET https://openlibrary.org/search.json
```

**Parameters:**
- `q`: Query pencarian (judul, author, subject)
- `limit`: Jumlah hasil (max 100)
- `fields`: Field yang diambil

**Contoh Request:**
```
https://openlibrary.org/search.json?q=subject:fiction&limit=40&fields=key,title,author_name,cover_i,first_publish_year,rating_average,subject
```

### 2. Cover Images
```
https://covers.openlibrary.org/b/id/{cover_id}-L.jpg
```

---

## 🧪 Testing

### Test API Langsung dengan curl
```bash
# Test search fiction novels
curl "https://openlibrary.org/search.json?q=subject:fiction&limit=5&fields=key,title,author_name,cover_i"

# Test search fantasy novels
curl "https://openlibrary.org/search.json?q=subject:fantasy&limit=5"

# Test search by title
curl "https://openlibrary.org/search.json?q=title:dragon&limit=5"
```

### Test di Aplikasi
1. Run aplikasi: `flutter run`
2. Check console untuk log API request
3. Pull-to-refresh di home screen untuk reload data

---

## 📊 Fitur yang Tersedia

| Fitur | Status | Keterangan |
|-------|--------|-----------|
| Browse Novels | ✅ | Tampilkan daftar novel dari Open Library |
| Search Novels | ✅ | Cari novel berdasarkan judul/author |
| Categories | ✅ | Filter berdasarkan kategori |
| Cover Images | ✅ | Tampilkan cover dari Open Library |
| Novel Detail | ✅ | Tampilkan detail novel |
| Favorites | ✅ | Simpan novel ke favorite |
| Bookmarks | ✅ | Bookmark posisi baca |
| Chapter Content | ⚠️ | **Tidak tersedia** di Open Library |

---

## ⚠️ Limitations

### 1. Tidak Ada Chapter Content
**Problem:** Open Library hanya menyediakan metadata buku, bukan isi buku.

**Solution:**
- Tampilkan metadata (title, author, cover, synopsis)
- Untuk baca full book, link ke Open Library website
- Atau gunakan API lain (Gutenberg) untuk chapter content

### 2. Rating Tidak Selalu Ada
**Workaround:** Default rating = 0 jika tidak tersedia

### 3. Cover Tidak Selalu Ada
**Workaround:** Fallback ke placeholder image

---

## 🔍 Debug Mode

Aktifkan logging untuk melihat request/response:

```dart
// Di api_client.dart - interceptor
onRequest: (options, handler) {
  print('REQUEST[${options.method}] => PATH: ${options.path}');
  return handler.next(options);
},
onResponse: (response, handler) {
  print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
  return handler.next(response);
},
```

---

## 📝 Contoh Response Open Library

```json
{
  "numFound": 12345,
  "start": 0,
  "docs": [
    {
      "key": "/works/OL12345W",
      "title": "Pride and Prejudice",
      "author_name": ["Jane Austen"],
      "cover_i": 123456,
      "first_publish_year": 1813,
      "rating_average": 4.5,
      "subject": ["Fiction", "Romance", "Classics"]
    }
  ]
}
```

---

## 🛠️ Troubleshooting

### Error: "Failed to load data"
1. Check koneksi internet
2. Pastikan URL API benar: `https://openlibrary.org`
3. Test API langsung dengan curl/browser

### Cover Image Tidak Muncul
1. Check cover_id valid
2. Test URL: `https://covers.openlibrary.org/b/id/{cover_id}-L.jpg`
3. Fallback ke placeholder jika gagal

### Data Kosong
1. Check query parameter
2. Coba kategori lain
3. Check log di console

---

## 📞 Support

- Stack Overflow: Tag `openlibrary`
- GitHub Issues: https://github.com/internetarchive/openlibrary/issues
- Forum: https://forum.openlibrary.org/

---

**Last Updated:** March 27, 2026
