class Novel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String category;
  final int chapters;
  final double rating;
  final String status; // ongoing, completed
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content; // Konten lengkap novel
  final int? gutenbergId; // Project Gutenberg ID untuk fetch content
  final Map<String, dynamic>? formats; // Format URLs untuk download

  Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.chapters,
    required this.rating,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.content = '',
    this.gutenbergId,
    this.formats,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    // Mapping untuk Gutendex API

    // Parse author
    String authorName = 'Unknown Author';
    final authors = json['authors'] as List?;
    if (authors != null && authors.isNotEmpty) {
      final firstAuthor = authors.first;
      if (firstAuthor is Map) {
        authorName = firstAuthor['name']?.toString() ?? 'Unknown Author';
      }
    }

    // Parse subjects untuk category
    List<String> subjectsList = [];
    final subjects = json['subjects'] as List?;
    if (subjects != null && subjects.isNotEmpty) {
      subjectsList = subjects.map((s) => s.toString()).toList();
    }

    // Parse bookshelves untuk category (prioritas utama)
    String category = 'Fiction';
    final bookshelves = json['bookshelves'] as List?;
    if (bookshelves != null && bookshelves.isNotEmpty) {
      // Gunakan bookshelf pertama sebagai category
      final bookshelf = bookshelves.first.toString();
      // Map bookshelf ke category name yang lebih user-friendly
      category = _mapBookshelfToCategory(bookshelf);
    } else if (subjectsList.isNotEmpty) {
      // Fallback ke subjects jika tidak ada bookshelves
      // Cari subject yang relevan untuk kategori
      final fictionSubject = subjectsList.firstWhere(
        (s) {
          final subject = s.toLowerCase();
          return subject.contains('fiction') ||
                 subject.contains('novel') ||
                 subject.contains('tale') ||
                 subject.contains('adventure') ||
                 subject.contains('romance') ||
                 subject.contains('mystery') ||
                 subject.contains('history');
        },
        orElse: () => subjectsList.first,
      );
      category = _mapSubjectToCategory(fictionSubject);
    }

    // Parse cover URL dari formats
    String coverUrl = '';
    final formats = json['formats'] as Map<String, dynamic>?;
    if (formats != null) {
      // Cari cover image
      final coverKey = formats.keys.firstWhere(
        (key) => key.contains('cover') || key.contains('image'),
        orElse: () => '',
      );
      if (coverKey.isNotEmpty) {
        coverUrl = formats[coverKey];
      }
    }

    // Fallback: Generate cover dari Gutenberg ID
    if (coverUrl.isEmpty && json['id'] != null) {
      coverUrl = 'https://www.gutenberg.org/cache/epub/${json['id']}/pg${json['id']}.cover.medium.jpg';
    }

    // Parse rating (Gutendex tidak menyediakan rating, default 0)
    double ratingValue = 0.0;

    // Parse tahun publikasi dari author birth/death year
    DateTime createdAt = DateTime.now();
    if (authors != null && authors.isNotEmpty) {
      final firstAuthor = authors.first as Map?;
      final birthYear = firstAuthor?['birth_year'];
      if (birthYear != null) {
        final year = birthYear is int ? birthYear : int.tryParse(birthYear.toString());
        if (year != null && year > 0) {
          createdAt = DateTime(year, 1, 1);
        }
      }
    }

    // Parse description dari summaries
    String description = '';
    final summaries = json['summaries'] as List?;
    if (summaries != null && summaries.isNotEmpty) {
      description = summaries.first.toString();
    }

    return Novel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown',
      author: authorName,
      description: description,
      coverUrl: coverUrl,
      category: category,
      chapters: 1, // Akan diupdate setelah fetch content
      rating: ratingValue,
      status: 'completed', // Gutenberg books are completed
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      gutenbergId: json['id'],
      formats: formats,
    );
  }

  // Helper function untuk map bookshelf ke category name
  static String _mapBookshelfToCategory(String bookshelf) {
    final lowerBookshelf = bookshelf.toLowerCase();

    // Map bookshelf ke category yang lebih sederhana
    if (lowerBookshelf.contains('children') || lowerBookshelf.contains('juvenile')) return 'Children';
    if (lowerBookshelf.contains('adventure')) return 'Adventure';
    if (lowerBookshelf.contains('detective') || lowerBookshelf.contains('mystery') || lowerBookshelf.contains('crime')) return 'Detective';
    if (lowerBookshelf.contains('science fiction') || lowerBookshelf.contains('sci-fi')) return 'Science Fiction';
    if (lowerBookshelf.contains('fantasy') || lowerBookshelf.contains('magic')) return 'Fantasy';
    if (lowerBookshelf.contains('romance') || lowerBookshelf.contains('love') || lowerBookshelf.contains('courtship')) return 'Romance';
    if (lowerBookshelf.contains('horror') || lowerBookshelf.contains('ghost') || lowerBookshelf.contains('supernatural')) return 'Horror';
    if (lowerBookshelf.contains('historical') || lowerBookshelf.contains('history') || lowerBookshelf.contains('ancient')) return 'Historical';
    if (lowerBookshelf.contains('literature') || lowerBookshelf.contains('classic') || lowerBookshelf.contains('british') || lowerBookshelf.contains('american')) return 'Literature';
    if (lowerBookshelf.contains('poetry') || lowerBookshelf.contains('poem')) return 'Poetry';
    if (lowerBookshelf.contains('philosophy') || lowerBookshelf.contains('ethics')) return 'Philosophy';
    if (lowerBookshelf.contains('religion') || lowerBookshelf.contains('spirit') || lowerBookshelf.contains('theology')) return 'Religion';
    if (lowerBookshelf.contains('biography') || lowerBookshelf.contains('memoir')) return 'Biography';
    if (lowerBookshelf.contains('war') || lowerBookshelf.contains('military') || lowerBookshelf.contains('naval')) return 'Historical';
    if (lowerBookshelf.contains('art') || lowerBookshelf.contains('painting') || lowerBookshelf.contains('sculpture')) return 'Art';
    if (lowerBookshelf.contains('music') || lowerBookshelf.contains('musical')) return 'Music';
    if (lowerBookshelf.contains('travel') || lowerBookshelf.contains('voyage')) return 'Travel';
    if (lowerBookshelf.contains('science') || lowerBookshelf.contains('natural') || lowerBookshelf.contains('physics')) return 'Science';
    if (lowerBookshelf.contains('fiction') || lowerBookshelf.contains('novel')) return 'Fiction';

    // Return 'Fiction' sebagai default jika tidak ada match
    return 'Fiction';
  }

  // Helper function untuk map subject ke category name
  static String _mapSubjectToCategory(String subject) {
    final lowerSubject = subject.toLowerCase();

    // Map subject ke category yang lebih sederhana dan user-friendly
    if (lowerSubject.contains('children') || lowerSubject.contains('juvenile')) return 'Children';
    if (lowerSubject.contains('adventure') || lowerSubject.contains('adventures')) return 'Adventure';
    if (lowerSubject.contains('detective') || lowerSubject.contains('mystery') || lowerSubject.contains('crime')) return 'Detective';
    if (lowerSubject.contains('science fiction') || lowerSubject.contains('sci-fi')) return 'Science Fiction';
    if (lowerSubject.contains('fantasy') || lowerSubject.contains('fantastic')) return 'Fantasy';
    if (lowerSubject.contains('romance') || lowerSubject.contains('love stories') || lowerSubject.contains('courtship')) return 'Romance';
    if (lowerSubject.contains('horror') || lowerSubject.contains('ghost') || lowerSubject.contains('supernatural')) return 'Horror';
    if (lowerSubject.contains('historical') || lowerSubject.contains('history') || lowerSubject.contains('biography')) return 'Historical';
    if (lowerSubject.contains('literature') || lowerSubject.contains('classic') || lowerSubject.contains('poetry')) return 'Literature';
    if (lowerSubject.contains('drama') || lowerSubject.contains('tragedy') || lowerSubject.contains('comedy')) return 'Literature';
    if (lowerSubject.contains('fiction') || lowerSubject.contains('novel') || lowerSubject.contains('tale')) return 'Fiction';
    if (lowerSubject.contains('war') || lowerSubject.contains('military') || lowerSubject.contains('naval')) return 'Historical';
    if (lowerSubject.contains('family') || lowerSubject.contains('domestic') || lowerSubject.contains('marriage')) return 'Romance';
    if (lowerSubject.contains('social') || lowerSubject.contains('society') || lowerSubject.contains('manners')) return 'Literature';
    if (lowerSubject.contains('psychological') || lowerSubject.contains('mental')) return 'Literature';
    if (lowerSubject.contains('political') || lowerSubject.contains('government')) return 'Historical';
    if (lowerSubject.contains('economic') || lowerSubject.contains('business')) return 'Historical';
    if (lowerSubject.contains('philosophy') || lowerSubject.contains('ethics')) return 'Literature';
    if (lowerSubject.contains('religion') || lowerSubject.contains('theology')) return 'Literature';
    if (lowerSubject.contains('travel') || lowerSubject.contains('description') || lowerSubject.contains('exploration')) return 'Adventure';
    if (lowerSubject.contains('science') || lowerSubject.contains('natural') || lowerSubject.contains('physics')) return 'Science Fiction';

    // Return 'Fiction' sebagai default jika tidak ada match
    return 'Fiction';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'cover': coverUrl,
      'category': category,
      'chapters': chapters,
      'rating': rating,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'content': content,
      'gutenberg_id': gutenbergId,
    };
  }

  Novel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? category,
    int? chapters,
    double? rating,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    int? gutenbergId,
    Map<String, dynamic>? formats,
  }) {
    return Novel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      category: category ?? this.category,
      chapters: chapters ?? this.chapters,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      gutenbergId: gutenbergId ?? this.gutenbergId,
      formats: formats ?? this.formats,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Novel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
