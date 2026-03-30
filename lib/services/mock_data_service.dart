import '../models/novel.dart';
import '../models/category.dart' as app_models;
import '../models/chapter.dart' as app_models;

/// Mock data service untuk testing tanpa API
/// Gunakan class ini jika belum ada API server
class MockDataService {
  // Mock Categories
  static final List<app_models.Category> categories = [
    app_models.Category(
      id: '1',
      name: 'Fantasy',
      description: 'Novel fantasy dengan dunia magis',
      icon: '🐉',
      novelCount: 150,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '2',
      name: 'Romance',
      description: 'Cerita cinta yang romantis',
      icon: '💕',
      novelCount: 200,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '3',
      name: 'Action',
      description: 'Aksi petualangan yang seru',
      icon: '⚔️',
      novelCount: 180,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '4',
      name: 'Sci-Fi',
      description: 'Fiksi ilmiah masa depan',
      icon: '🚀',
      novelCount: 120,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '5',
      name: 'Mystery',
      description: 'Misteri yang penuh teka-teki',
      icon: '🔍',
      novelCount: 90,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '6',
      name: 'Horror',
      description: 'Cerita menyeramkan',
      icon: '👻',
      novelCount: 75,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '7',
      name: 'Comedy',
      description: 'Komedi lucu menghibur',
      icon: '😂',
      novelCount: 110,
      createdAt: DateTime.now(),
    ),
    app_models.Category(
      id: '8',
      name: 'Drama',
      description: 'Drama kehidupan yang mendalam',
      icon: '🎭',
      novelCount: 95,
      createdAt: DateTime.now(),
    ),
  ];

  // Mock Novels
  static final List<Novel> novels = [
    Novel(
      id: '1',
      title: 'The Dragon\'s Heir',
      author: 'Sarah Chen',
      description: 'Seorang pemuda biasa menemukan bahwa dia adalah pewaris terakhir dari garis keturunan naga. Kini dia harus belajar menguasai kekuatan barunya sambil menghindari mereka yang ingin mengeksploitasinya.',
      coverUrl: 'https://picsum.photos/seed/novel1/400/600',
      category: 'Fantasy',
      chapters: 245,
      rating: 4.8,
      status: 'ongoing',
      createdAt: DateTime(2023, 1, 15),
      updatedAt: DateTime(2024, 3, 20),
    ),
    Novel(
      id: '2',
      title: 'Love in the Stars',
      author: 'Emma Rose',
      description: 'Kisah cinta terlarang antara seorang astronaut dan alien dari planet jauh. Akankah cinta mereka mengatasi perbedaan spesies dan jarak antar bintang?',
      coverUrl: 'https://picsum.photos/seed/novel2/400/600',
      category: 'Romance',
      chapters: 120,
      rating: 4.5,
      status: 'completed',
      createdAt: DateTime(2023, 3, 10),
      updatedAt: DateTime(2024, 2, 14),
    ),
    Novel(
      id: '3',
      title: 'Shadow Assassin',
      author: 'Mike Storm',
      description: 'Seorang assassin terheap di dunia bayangan menerima misi yang mustahil. Tapi ketika dia menemukan targetnya adalah seseorang dari masa lalunya, semuanya berubah.',
      coverUrl: 'https://picsum.photos/seed/novel3/400/600',
      category: 'Action',
      chapters: 380,
      rating: 4.7,
      status: 'ongoing',
      createdAt: DateTime(2022, 11, 5),
      updatedAt: DateTime(2024, 3, 25),
    ),
    Novel(
      id: '4',
      title: 'Galactic Empire',
      author: 'Alex Nova',
      description: 'Di masa depan yang jauh, manusia telah menyebar ke seluruh galaksi. Seorang pilot muda terjebak dalam perang antar bintang yang akan menentukan nasib umat manusia.',
      coverUrl: 'https://picsum.photos/seed/novel4/400/600',
      category: 'Sci-Fi',
      chapters: 290,
      rating: 4.6,
      status: 'ongoing',
      createdAt: DateTime(2023, 5, 20),
      updatedAt: DateTime(2024, 3, 18),
    ),
    Novel(
      id: '5',
      title: 'The Last Detective',
      author: 'Rachel Green',
      description: 'Seorang detektif swasta dengan kemampuan khusus memecahkan kasus-kasus yang mustahil. Tapi kasus terbaru ini mungkin terlalu bahkan untuknya.',
      coverUrl: 'https://picsum.photos/seed/novel5/400/600',
      category: 'Mystery',
      chapters: 156,
      rating: 4.4,
      status: 'completed',
      createdAt: DateTime(2023, 2, 8),
      updatedAt: DateTime(2024, 1, 30),
    ),
    Novel(
      id: '6',
      title: 'Haunted Academy',
      author: 'Dark Writer',
      description: 'Sekolah asrama tua menyimpan rahasia gelap. Siswa baru mulai menghilang satu per satu, dan hanya segelintir orang yang menyadari ada sesuatu yang jahat di dalam sekolah.',
      coverUrl: 'https://picsum.photos/seed/novel6/400/600',
      category: 'Horror',
      chapters: 98,
      rating: 4.3,
      status: 'ongoing',
      createdAt: DateTime(2023, 8, 15),
      updatedAt: DateTime(2024, 3, 22),
    ),
    Novel(
      id: '7',
      title: 'My Roommate is a Demon',
      author: 'Comedy King',
      description: 'Kehidupan sehari-hari seorang mahasiswa biasa yang tidak sengaja memanggil demon dan sekarang harus hidup bersamanya. Situasi kacau dan lucu tak terhindarkan!',
      coverUrl: 'https://picsum.photos/seed/novel7/400/600',
      category: 'Comedy',
      chapters: 175,
      rating: 4.9,
      status: 'ongoing',
      createdAt: DateTime(2023, 4, 1),
      updatedAt: DateTime(2024, 3, 26),
    ),
    Novel(
      id: '8',
      title: 'Tears of the Phoenix',
      author: 'Drama Queen',
      description: 'Seorang seniman kehilangan segalanya dalam kebakaran. Dari puing-puing kehidupannya, dia harus membangun kembali dan menemukan makna sejati dari seni dan kehidupan.',
      coverUrl: 'https://picsum.photos/seed/novel8/400/600',
      category: 'Drama',
      chapters: 88,
      rating: 4.7,
      status: 'completed',
      createdAt: DateTime(2023, 6, 12),
      updatedAt: DateTime(2024, 2, 28),
    ),
    Novel(
      id: '9',
      title: 'Sword of Destiny',
      author: 'Blade Master',
      description: 'Pedang legendaris yang dapat mengubah takdir dunia. Berbagai faksi berebut untuk mendapatkannya, tapi hanya satu yang layak wield senjata suci ini.',
      coverUrl: 'https://picsum.photos/seed/novel9/400/600',
      category: 'Fantasy',
      chapters: 420,
      rating: 4.8,
      status: 'ongoing',
      createdAt: DateTime(2022, 9, 3),
      updatedAt: DateTime(2024, 3, 27),
    ),
    Novel(
      id: '10',
      title: 'CEO\'s Secret Love',
      author: 'Romance Writer',
      description: 'Seorang CEO dingin dan kejam ternyata menyimpan rahasia: dia telah mencintai asistennya selama bertahun-tahun tapi tidak tahu cara mengungkapkannya.',
      coverUrl: 'https://picsum.photos/seed/novel10/400/600',
      category: 'Romance',
      chapters: 200,
      rating: 4.6,
      status: 'ongoing',
      createdAt: DateTime(2023, 7, 7),
      updatedAt: DateTime(2024, 3, 24),
    ),
    Novel(
      id: '11',
      title: 'Cyber Revolution',
      author: 'Tech Guru',
      description: 'Di dunia yang dikuasai korporasi teknologi, seorang hacker muda memimpin revolusi untuk mengembalikan kebebasan internet. Perang digital pun dimulai.',
      coverUrl: 'https://picsum.photos/seed/novel11/400/600',
      category: 'Sci-Fi',
      chapters: 165,
      rating: 4.5,
      status: 'ongoing',
      createdAt: DateTime(2023, 9, 18),
      updatedAt: DateTime(2024, 3, 21),
    ),
    Novel(
      id: '12',
      title: 'Midnight Murders',
      author: 'Mystery Master',
      description: 'Serial killer hanya beraksi saat tengah malam. Seorang profiler FBI dengan masa lalu kelam harus menangkapnya sebelum menjadi terlalu terlambat.',
      coverUrl: 'https://picsum.photos/seed/novel12/400/600',
      category: 'Mystery',
      chapters: 134,
      rating: 4.7,
      status: 'completed',
      createdAt: DateTime(2023, 1, 25),
      updatedAt: DateTime(2024, 3, 10),
    ),
  ];

  // Get all categories
  Future<List<app_models.Category>> getCategories() async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    return categories;
  }

  // Get all novels
  Future<List<Novel>> getNovels({String? category}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (category != null && category.isNotEmpty) {
      return novels.where((n) => n.category.toLowerCase() == category.toLowerCase()).toList();
    }
    
    return novels;
  }

  // Get novel by ID
  Future<Novel?> getNovelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return novels.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search novels
  Future<List<Novel>> searchNovels(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (query.isEmpty) {
      return novels;
    }
    
    final lowerQuery = query.toLowerCase();
    return novels.where((n) => 
      n.title.toLowerCase().contains(lowerQuery) ||
      n.author.toLowerCase().contains(lowerQuery) ||
      n.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Get chapters (mock) - Generate dynamically for any novel
  Future<List<app_models.Chapter>> getChapters(String novelId, {String? title, String? author, int? chapterCount}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Try to find novel in mock data, if not found use provided params or defaults
    Novel? novel;
    try {
      novel = novels.firstWhere((n) => n.id == novelId);
    } catch (e) {
      // Novel not found in mock data, use provided parameters
      novel = null;
    }

    final novelTitle = title ?? novel?.title ?? 'Unknown Novel';
    final novelAuthor = author ?? novel?.author ?? 'Unknown Author';
    final totalChapters = chapterCount ?? novel?.chapters ?? 10;

    List<app_models.Chapter> chapters = [];

    for (int i = 1; i <= totalChapters; i++) {
      chapters.add(app_models.Chapter(
        id: '$i',
        title: 'Chapter $i',
        number: i,
        novelId: novelId,
        content: _generateChapterContent(i, novelTitle, novelAuthor),
        publishedAt: DateTime.now().subtract(Duration(days: totalChapters - i)),
        wordCount: 2000 + (i * 100),
      ));
    }

    return chapters;
  }

  // Get chapter detail
  Future<app_models.Chapter?> getChapterDetail(String novelId, String chapterId, {String? title, String? author}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final chapters = await getChapters(novelId, title: title, author: author);
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (e) {
      return null;
    }
  }

  // Generate mock chapter content
  String _generateChapterContent(int chapterNum, String novelTitle, String author) {
    return '''
Chapter $chapterNum - $novelTitle
Written by $author

***

Pagi itu matahari mulai terbit dari ufuk timur, menyinari pegunungan yang masih diselimuti kabut tipis. Angin sepoi-sepoi bertiup melewati pepohonan, membawa serta aroma tanah basah setelah semalam turun hujan.

Di sebuah desa kecil di kaki gunung, seorang pemuda bernama Arya sedang duduk bersila di beranda rumah kayu sederhana miliknya. Matanya yang tajam menatap kosong ke arah hutan lebat di kejauhan, seolah sedang mencari sesuatu yang hilang dari ingatannya.

"Arya! Kau sudah siap?" teriak seorang wanita dari dalam rumah.

Pemuda itu menoleh, "Sebentar lagi, Bu!" jawabnya sambil berdiri dan merapikan pakaiannya.

Hari ini adalah hari yang penting baginya. Setelah bertahun-tahun berlatih dan mempersiapkan diri, akhirnya dia akan mengikuti ujian masuk akademi penyihir terbesar di kerajaan. Impian yang sudah dia pendam sejak kecil akhirnya akan segera terwujud.

Tapi ada sesuatu yang mengganjal di hatinya. Semalam, dia bermimpi aneh. Dalam mimpinya, dia melihat sebuah cahaya terang di tengah hutan terlarang—hutan yang konon angker dan tidak pernah ada orang yang berani memasukinya.

"Apa arti mimpi itu?" gumamnya sambil mengambil tas kulit usang miliknya.

Ibunya keluar dari rumah dengan membawa bekal makanan. "Ini untuk perjalananmu. Jangan lupa makan ya," katanya sambil menyerahkan bungkusan itu.

Arya menerima bekal itu dengan senyuman. "Terima kasih, Bu. Doakan aku ya."

"Tentu saja, Nak. Ibu selalu mendoakanmu. Jadilah penyihir hebat dan buatlah nama baik untuk keluarga kita."

Setelah berpamitan dengan ibunya, Arya mulai berjalan menuju jalan setapak yang akan membawanya ke kota tempat akademi berada. Langkahnya mantap meski dalam hati masih ada keraguan tentang mimpi semalam.

Di tengah perjalanan, dia bertemu dengan seorang kakek tua yang duduk di pinggir jalan. Kakek itu tampak lemah dan kelaparan.

"Nak, apakah kau punya makanan? Sudah tiga hari aku tidak makan," kata kakek itu dengan suara parau.

Tanpa ragu, Arya memberikan separuh dari bekal yang diberikan ibunya. "Ini, Kek. Silakan makan."

Kakek itu makan dengan lahap. Setelah selesai, dia menatap Arya dengan mata yang tiba-tiba menjadi tajam dan bercahaya.

"Kau anak baik, Arya. Kebaikan hatimu akan membawamu pada jalan yang benar. Tapi ingatlah ini—kekuatan sejati bukan berasal dari seberapa hebat sihir yang kau kuasai, tapi dari seberapa besar kau menggunakan kekuatan itu untuk membantu orang lain."

Arya terkejut. "Bagaimana Kau tahu namaku?"

Tapi saat dia berkedip, kakek itu sudah tidak ada di sana. Yang tersisa hanya sebuah kalung kecil dengan liontin berbentuk bintang di tempat kakek itu tadi duduk.

Dengan tangan gemetar, Arya mengambil kalung itu. Saat dia menyentuhnya, tiba-tiba dia merasakan aliran energi hangat menjalar ke seluruh tubuhnya.

"Apa... apa ini?" bisiknya bingung.

Tanpa dia sadari, perjalanan hidupnya sebagai calon penyihir baru saja dimulai. Dan kalung misterius itu akan menjadi kunci dari takdir besar yang menantinya.

***

Di tempat yang jauh, di sebuah istana gelap di dimensi lain, sepasang mata merah terbuka perlahan.

"Dia sudah ditemukan," suara berat bergema di ruangan itu. "Bawa dia kepadaku. Sebelum dia menyadari kekuatan sebenarnya."

"Hamba akan segera berangkat, Yang Mulia," jawab sosok berjubah hitam yang berlutut di hadapannya.

Malam itu, bayang-bayang mulai bergerak. Dan Arya, yang masih dalam perjalanan ke akademi, sama sekali tidak menyadari bahwa hidupnya akan segera berubah selamanya.

---

[Ini adalah content mock untuk demo. Untuk production, content asli harus diambil dari API database.]

Word Count: ${2000 + (chapterNum * 100)}
''';
  }
}
