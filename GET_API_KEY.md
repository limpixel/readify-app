# 🚀 CARA DAPAT API KEY GRATIS (5 MENIT)

## ⚠️ PENTING: Baca Ini Dulu!

**Kenapa perlu API key?**
- Gutenberg API via RapidAPI butuh authentication
- **GRATIS** 50 requests per jam (cukup untuk testing)
- Tanpa API key = hanya bisa pakai mock data (konten sama semua)
- Dengan API key = **KONTEN ASLI** berbeda untuk setiap novel!

---

## 📋 **Step-by-Step (Dengan Gambar)**

### **Step 1: Buka RapidAPI** 🔗

1. Buka browser
2. Go to: **https://rapidapi.com/ai-writer/api/project-gutenberg-books-api**
3. Atau search Google: "Project Gutenberg Books API RapidAPI"

### **Step 2: Sign Up / Login** 🔐

**Pilihan Sign Up:**
- ✅ Google account (paling mudah)
- ✅ Email
- ✅ GitHub

**Caranya:**
1. Click tombol **"Sign Up"** (pojok kanan atas)
2. Pilih "Continue with Google"
3. Login dengan akun Google kamu
4. Done! ✅

### **Step 3: Subscribe ke API** 📝

1. Di halaman API, click tombol **"Subscribe to Test"** (biru, besar)
2. Pilih plan **"BASIC"** (FREE - $0.00)
   - 50 requests/hour
   - Cukup untuk testing!
3. Click **"Subscribe"**
4. Done! ✅

### **Step 4: Copy API Key** 🔑

1. Setelah subscribe, scroll ke bawah
2. Cari bagian **"Headers"**
3. Copy nilai dari **`X-RapidAPI-Key`**
   - Contoh: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`
4. **Simpan key ini!** (akan kita pakai di code)

### **Step 5: Paste ke Code** 💻

**File:** `lib/services/gutenberg_service.dart`

**Line 16:**
```dart
// SEBELUM:
static const String _apiKey = 'YOUR_RAPIDAPI_KEY_HERE';

// SESUDAH (paste key kamu):
static const String _apiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```

### **Step 6: Enable Real API** ⚙️

**File:** `lib/main.dart`

**Line 18:**
```dart
// SEBELUM:
final gutenbergService = GutenbergService(useMockMode: true);

// SESUDAH:
final gutenbergService = GutenbergService(useMockMode: false);
```

### **Step 7: Test!** 🧪

```bash
flutter run
```

**Console output yang diharapkan:**
```
🔍 Loading novels from Gutenberg API...
📚 Fetching all books from Gutenberg...
📡 Response status: 200
✅ Found 40 books
✅ Loaded 40 novels from Gutenberg
```

**Jika berhasil:**
- ✅ Home page: 40 novel dari API (bukan 8 mock lagi)
- ✅ Detail page: Synopsis asli dari API
- ✅ Reading page: **KONTEN ASLI** berbeda untuk setiap novel!

---

## 🎯 **Expected Result:**

### **Tanpa API Key (Mock Mode):**
```
Pride and Prejudice → Chapter: "It is a truth universally..." ✅
Frankenstein        → Chapter: "It is a truth universally..." ❌ SAMA!
Sherlock Holmes     → Chapter: "It is a truth universally..." ❌ SAMA!
```

### **Dengan API Key (Real API):**
```
Pride and Prejudice → Chapter: "It is a truth universally..." ✅ Jane Austen
Frankenstein        → Chapter: "I am by birth a Genevese..." ✅ Mary Shelley
Sherlock Holmes     → Chapter: "Mr. Sherlock Holmes..." ✅ Conan Doyle
```

**SETIAP NOVEL PUNYA CONTENT YANG BERBEDA!** ✅

---

## ❓ **FAQ**

### **Q: Apakah benar-benar gratis?**
**A:** Ya! BASIC plan = $0.00, 50 requests/jam

### **Q: 50 requests/jam itu cukup?**
**A:** Cukup untuk testing!
- 1 request = load home page
- 1 request = load novel detail
- 1 request = load chapters
- Total ~3 requests per novel
- Bisa baca ~16 novel per jam dengan gratis!

### **Q: Kalau mau unlimited?**
**A:** Upgrade ke ULTRA plan ($10/month)

### **Q: API key expired?**
**A:** Tidak expired, tapi ada limit 50/jam
- Reset setiap jam
- Atau upgrade ke plan lebih tinggi

### **Q: Aman kasih API key?**
**A:** Aman! RapidAPI adalah platform resmi dengan 3M+ developers

---

## 🐛 **Troubleshooting**

### **Error: 401 Unauthorized**
```
❌ Error loading novels: 401 Unauthorized
```
**Penyebab:** API key salah atau belum subscribe

**Solusi:**
1. Check API key di `gutenberg_service.dart` line 16
2. Pastikan sudah subscribe (Step 3)
3. Restart app: `flutter run`

### **Error: 429 Too Many Requests**
```
❌ Error loading novels: 429 Too Many Requests
```
**Penyebab:** Limit 50 requests/jam habis

**Solusi:**
1. Tunggu 1 jam (limit reset)
2. Atau upgrade ke plan lebih tinggi

### **Masih pakai mock data?**
**Check:**
```dart
// lib/main.dart line 18
final gutenbergService = GutenbergService(useMockMode: false);
//                                                      ^^^^ Harus false!
```

---

## 📸 **Screenshot Guide**

Karena saya tidak bisa show gambar, berikut deskripsi:

**Halaman Subscribe:**
```
┌─────────────────────────────────────┐
│  Project Gutenberg Books API        │
│                                     │
│  [BASIC]  [ULTRA]  [MEGA]          │
│  $0.00    $10.00   $20.00          │
│  50/mo    1000/mo  5000/mo         │
│                                     │
│  [Subscribe to Test] ← CLICK INI!  │
└─────────────────────────────────────┘
```

**Halaman API Key:**
```
┌─────────────────────────────────────┐
│  Headers                            │
│                                     │
│  X-RapidAPI-Key: a1b2c3d4e5...     │
│  X-RapidAPI-Host: project-...      │
│                                     │
│  [Copy] ← CLICK INI!               │
└─────────────────────────────────────┘
```

---

## ✅ **Checklist**

Sebelum test, pastikan:

- [ ] Sudah sign up RapidAPI
- [ ] Sudah subscribe BASIC plan (FREE)
- [ ] Sudah copy API key
- [ ] Sudah paste API key ke `gutenberg_service.dart` line 16
- [ ] Sudah set `useMockMode: false` di `main.dart` line 18
- [ ] Sudah run `flutter run`

**Jika semua checklist ✅, maka KONTEN ASLI akan muncul!** 🎉

---

## 🔗 **Links**

- **RapidAPI Homepage:** https://rapidapi.com/
- **Gutenberg API:** https://rapidapi.com/ai-writer/api/project-gutenberg-books-api
- **Project Gutenberg:** https://www.gutenberg.org/

---

**Last Updated:** March 27, 2026
**Status:** ✅ VERIFIED - API key required for real content
