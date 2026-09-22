import '../../data/models/note_model.dart';

abstract class NoteRepository {
  Future<List<NoteModel>> getNotes();
  Future<void> saveNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<void> saveNotes(List<NoteModel> notes);
}
