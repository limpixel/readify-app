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
    String category = 'Fiction';
    final subjects = json['subjects'] as List?;
    if (subjects != null && subjects.isNotEmpty) {
      // Cari subject yang relevan
      final fictionSubject = subjects.firstWhere(
        (s) {
          final subject = s.toString().toLowerCase();
          return subject.contains('fiction') || 
                 subject.contains('novel') || 
                 subject.contains('tale') ||
                 subject.contains('adventure');
        },
        orElse: () => subjects.first,
      );
      category = fictionSubject.toString();
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
