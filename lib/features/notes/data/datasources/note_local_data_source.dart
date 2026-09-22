import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> saveNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<void> saveNotes(List<NoteModel> notes);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<NoteModel> _box;

  NoteLocalDataSourceImpl(this._box);

  @override
  Future<List<NoteModel>> getNotes() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveNote(NoteModel note) async {
    await _box.put(note.id, note);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> saveNotes(List<NoteModel> notes) async {
    final Map<String, NoteModel> notesMap = {
      for (var note in notes) note.id: note,
    };
    await _box.putAll(notesMap);
  }
}
