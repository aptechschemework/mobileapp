import 'package:hive/hive.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final List<String> tags;
  final int colorValue;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.category = 'Uncategorized',
    this.tags = const [],
    this.colorValue = 0,
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.reminderAt,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    List<String>? tags,
    int? colorValue,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderAt: reminderAt ?? this.reminderAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'tags': tags,
      'colorValue': colorValue,
      'isPinned': isPinned,
      'isFavorite': isFavorite,
      'isArchived': isArchived,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reminderAt': reminderAt?.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: (json['category'] as String?) ?? 'Uncategorized',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      colorValue: (json['colorValue'] as num?)?.toInt() ?? 0,
      isPinned: (json['isPinned'] as bool?) ?? false,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
      isArchived: (json['isArchived'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reminderAt: json['reminderAt'] != null ? DateTime.parse(json['reminderAt'] as String) : null,
    );
  }
}

// Manual Hive TypeAdapter
class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      category: fields[3] as String? ?? 'Uncategorized',
      tags: (fields[4] as List?)?.cast<String>() ?? [],
      colorValue: fields[5] as int? ?? 0,
      isPinned: fields[6] as bool? ?? false,
      isFavorite: fields[7] as bool? ?? false,
      isArchived: fields[8] as bool? ?? false,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      reminderAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.isPinned)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.isArchived)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.reminderAt);
  }
}
