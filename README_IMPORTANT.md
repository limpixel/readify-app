# ⚠️ BACA INI DULU! - PENTING!

## 🎯 **KENAPA KONTEN MASIH SAMA?**

**Jawaban:** Karena kamu **BELUM PAKAI API KEY**!

Selama kamu pakai `useMockMode: true` atau API key belum di-set, aplikasi akan pakai **MOCK DATA** yang kontennya **SAMA UNTUK SEMUA NOVEL**.

---

## ✅ **SOLUSI: 5 MENIT DAPAT API KEY GRATIS!**

### **Step 1: Buka Link Ini** 🔗

👉 **https://rapidapi.com/ai-writer/api/project-gutenberg-books-api**

### **Step 2: Sign Up (GRATIS)** 🔐

1. Click **"Sign Up"** (pojok kanan atas)
2. Pilih **"Continue with Google"**
3. Login dengan akun Google kamu
4. Done! ✅

### **Step 3: Subscribe** 📝

1. Click tombol **"Subscribe to Test"** (biru, besar)
2. Pilih plan **"BASIC"** ($0.00 - **GRATIS**)
3. Click **"Subscribe"**
4. Done! ✅

### **Step 4: Copy API Key** 🔑

1. Scroll ke bawah cari **"Headers"**
2. Copy nilai dari **`X-RapidAPI-Key`**
   - Contoh: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`
3. Simpan! ✅

### **Step 5: Paste ke Code** 💻

**File:** `lib/services/gutenberg_service.dart`

**Line 23:**
```dart
// GANTI INI:
static const String _apiKey = 'YOUR_RAPIDAPI_KEY_HERE';

// MENJADI (paste key kamu):
static const String _apiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```

### **Step 6: Set useMockMode: false** ⚙️

**File:** `lib/main.dart`

**Line 26:**
```dart
// GANTI INI:
final gutenbergService = GutenbergService(
  useMockMode: true, // ❌ MOCK MODE - konten SAMA semua!
);

// MENJADI:
final gutenbergService = GutenbergService(
  useMockMode: false, // ✅ REAL API - konten ASLI berbeda!
);
```

### **Step 7: Run!** 🚀

```bash
flutter run
```

---

## 🎯 **HASIL AKHIR:**

### **SEBELUM (Tanpa API Key):**
```
Novel: Pride and Prejudice
Chapter 1: "It is a truth universally..." ✅

Novel: Frankenstein  
Chapter 1: "It is a truth universally..." ❌ SAMA!

Novel: Sherlock Holmes
Chapter 1: "It is a truth universally..." ❌ SAMA!
```

### **SESUDAH (Dengan API Key):**
```
Novel: Pride and Prejudice
Chapter 1: "It is a truth universally acknowledged..." ✅ Jane Austen

Novel: Frankenstein  
Chapter 1: "I am by birth a Genevese..." ✅ Mary Shelley

Novel: Sherlock Holmes
Chapter 1: "Mr. Sherlock Holmes, who was usually very late..." ✅ Conan Doyle
```

**SETIAP NOVEL PUNYA CONTENT YANG BERBEDA!** ✅

---

## 📊 **PERBEDAAN MOCK vs REAL:**

| Feature | Mock Mode (Tanpa API Key) | Real API (Dengan API Key) |
|---------|--------------------------|---------------------------|
| **Jumlah Novel** | 8 | 76,000+ |
| **Cover** | ✅ Gutenberg | ✅ Gutenberg |
| **Synopsis** | ✅ Ada | ✅ Ada |
| **Chapter Content** | ❌ SAMA semua | ✅ **BERBEDA per novel!** |
| **Author Match** | ❌ Tidak sesuai | ✅ Sesuai author asli |
| **Full Text** | ❌ Sample saja | ✅ **FULL TEXT asli!** |
| **API Key** | ❌ Tidak perlu | ✅ **PERLU!** |
| **Cost** | ✅ Gratis | ✅ Gratis (50/jam) |

---

## ❓ **FAQ**

### **Q: Apakah benar-benar gratis?**
**A:** YA! BASIC plan = $0.00, 50 requests per jam

### **Q: 50 requests/jam cukup?**
**A:** Cukup untuk testing!
- Load home page = 1 request
- Load detail = 1 request  
- Load chapters = 1 request
- Total: ~3 requests per novel
- Bisa baca **16 novel per jam** gratis!

### **Q: Kalau mau unlimited?**
**A:** Upgrade ke ULTRA plan ($10/month, 1000 requests/jam)

### **Q: API key expired?**
**A:** Tidak expired, tapi ada limit 50/jam
- Limit reset setiap jam
- Atau upgrade ke plan berbayar

### **Q: Aman kasih API key?**
**A:** AMAN! RapidAPI platform resmi dengan 3M+ developers

---

## 🐛 **TROUBLESHOOTING**

### **Console Output: "WARNING: API key belum di-set!"**
```
⚠️ WARNING: API key belum di-set!
⚠️ Menggunakan mock data (konten SAMA untuk semua novel)
```

**Penyebab:** API key masih `'YOUR_RAPIDAPI_KEY_HERE'`

**Solusi:**
1. Buka `lib/services/gutenberg_service.dart`
2. Line 23: Ganti `'YOUR_RAPIDAPI_KEY_HERE'` dengan API key asli
3. Run ulang: `flutter run`

### **Console Output: "401 Unauthorized"**
```
❌ Error 401: API key tidak valid!
```

**Penyebab:** API key salah atau belum subscribe

**Solusi:**
1. Check API key di `gutenberg_service.dart` line 23
2. Pastikan sudah subscribe di RapidAPI
3. Run ulang

### **Console Output: "429 Too Many Requests"**
```
⚠️ Error 429: Limit API habis (50 requests/jam)
```

**Penyebab:** Limit 50 requests/jam sudah habis

**Solusi:**
1. Tunggu 1 jam (limit reset otomatis)
2. Atau upgrade ke plan berbayar

### **Masih Konten Sama?**
**Check:**
```dart
// lib/main.dart line 26
final gutenbergService = GutenbergService(
  useMockMode: false, // ← HARUS FALSE!
);
```

---

## ✅ **CHECKLIST SEBELUM RUN**

- [ ] Sudah sign up RapidAPI
- [ ] Sudah subscribe BASIC plan (FREE)
- [ ] Sudah copy API key
- [ ] Sudah paste API key ke `gutenberg_service.dart` line 23
- [ ] API key BUKAN `'YOUR_RAPIDAPI_KEY_HERE'` lagi
- [ ] Sudah set `useMockMode: false` di `main.dart` line 26
- [ ] Sudah run `flutter run`

**Jika semua ✅, maka KONTEN ASLI akan muncul!** 🎉

---

## 📖 **FILES YANG PENTING:**

| File | Line | Yang Dicek |
|------|------|-----------|
| `lib/services/gutenberg_service.dart` | 23 | API key sudah di-paste? |
| `lib/main.dart` | 26 | `useMockMode: false`? |
| `GET_API_KEY.md` | - | Tutorial lengkap dapat API key |

---

## 🔗 **LINKS:**

- **RapidAPI:** https://rapidapi.com/
- **Gutenberg API:** https://rapidapi.com/ai-writer/api/project-gutenberg-books-api
- **Tutorial Lengkap:** Lihat `GET_API_KEY.md`

---

## 🎉 **KESIMPULAN:**

**UNTUK KONTEN ASLI YANG BERBEDA PER NOVEL:**

1. ✅ Dapat API key GRATIS (5 menit)
2. ✅ Paste ke `gutenberg_service.dart` line 23
3. ✅ Set `useMockMode: false` di `main.dart`
4. ✅ Run `flutter run`
5. ✅ **DONE!** Konten asli berbeda untuk setiap novel!

**TANPA API KEY = KONTEN SAMA SEMUA!** ❌
**DENGAN API KEY = KONTEN ASLI BERBEDA!** ✅

---

**Last Updated:** March 27, 2026
**Status:** ⚠️ API KEY REQUIRED FOR REAL CONTENT
