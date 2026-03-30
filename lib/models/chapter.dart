class Chapter {
  final String id;
  final String title;
  final int number;
  final String content;
  final String novelId;
  final DateTime publishedAt;
  final int wordCount;

  Chapter({
    required this.id,
    required this.title,
    required this.number,
    this.content = '', // Optional - bisa dari novel content
    required this.novelId,
    required this.publishedAt,
    this.wordCount = 0,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      number: json['number'] ?? 0,
      content: json['content']?.toString() ?? '',
      novelId: json['novel_id']?.toString() ?? '',
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : DateTime.now(),
      wordCount: json['word_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'content': content,
      'novel_id': novelId,
      'published_at': publishedAt.toIso8601String(),
      'word_count': wordCount,
    };
  }

  Chapter copyWith({
    String? id,
    String? title,
    int? number,
    String? content,
    String? novelId,
    DateTime? publishedAt,
    int? wordCount,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      content: content ?? this.content,
      novelId: novelId ?? this.novelId,
      publishedAt: publishedAt ?? this.publishedAt,
      wordCount: wordCount ?? this.wordCount,
    );
  }
}
