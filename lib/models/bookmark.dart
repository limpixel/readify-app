class Bookmark {
  final String id;
  final String name;
  final String description;
  final List<String> novelIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bookmark({
    required this.id,
    required this.name,
    required this.description,
    required this.novelIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    List<String> novelIds = [];
    if (json['novel_ids'] != null) {
      if (json['novel_ids'] is List) {
        novelIds = json['novel_ids'].map((id) => id.toString()).toList();
      } else if (json['novel_ids'] is String) {
        novelIds = json['novel_ids'].split(',').where((s) => s.isNotEmpty).toList();
      }
    }

    return Bookmark(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      novelIds: novelIds,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'novel_ids': novelIds.join(','),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Bookmark copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? novelIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      novelIds: novelIds ?? List.from(this.novelIds),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool hasNovel(String novelId) {
    return novelIds.contains(novelId);
  }

  Bookmark addNovel(String novelId) {
    if (!novelIds.contains(novelId)) {
      return copyWith(
        novelIds: [...novelIds, novelId],
        updatedAt: DateTime.now(),
      );
    }
    return this;
  }

  Bookmark removeNovel(String novelId) {
    if (novelIds.contains(novelId)) {
      return copyWith(
        novelIds: novelIds.where((id) => id != novelId).toList(),
        updatedAt: DateTime.now(),
      );
    }
    return this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bookmark && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
