import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/features/notes/data/models/note_model.dart';

void main() {
  group('NoteModel Tests', () {
    final now = DateTime.now();

    test('Note creation works with default values', () {
      final note = NoteModel(
        id: 'test-id-1',
        title: 'Test Note',
        content: 'Test content here',
        createdAt: now,
        updatedAt: now,
      );

      expect(note.id, 'test-id-1');
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content here');
      expect(note.category, 'Uncategorized');
      expect(note.tags, isEmpty);
      expect(note.colorValue, 0);
      expect(note.isPinned, false);
      expect(note.isFavorite, false);
      expect(note.isArchived, false);
    });

    test('copyWith works correctly', () {
      final note = NoteModel(
        id: 'test-id-1',
        title: 'Original Title',
        content: 'Original Content',
        createdAt: now,
        updatedAt: now,
      );

      final updatedNote = note.copyWith(
        title: 'Updated Title',
        isPinned: true,
      );

      expect(updatedNote.id, 'test-id-1');
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.content, 'Original Content');
      expect(updatedNote.isPinned, true);
    });

    test('toJson and fromJson work correctly (parsing validation)', () {
      final note = NoteModel(
        id: 'json-id',
        title: 'JSON Note',
        content: 'JSON content testing',
        category: 'Work',
        tags: ['urgent', 'tech'],
        colorValue: 3,
        isPinned: true,
        isFavorite: false,
        isArchived: false,
        createdAt: DateTime(2026, 9, 22, 10, 0),
        updatedAt: DateTime(2026, 9, 22, 11, 0),
      );

      final jsonMap = note.toJson();
      final parsedNote = NoteModel.fromJson(jsonMap);

      expect(parsedNote.id, note.id);
      expect(parsedNote.title, note.title);
      expect(parsedNote.content, note.content);
      expect(parsedNote.category, note.category);
      expect(parsedNote.tags, note.tags);
      expect(parsedNote.colorValue, note.colorValue);
      expect(parsedNote.isPinned, note.isPinned);
      expect(parsedNote.isFavorite, note.isFavorite);
      expect(parsedNote.isArchived, note.isArchived);
      expect(parsedNote.createdAt, note.createdAt);
      expect(parsedNote.updatedAt, note.updatedAt);
    });
  });
}
