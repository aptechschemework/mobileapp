import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Future<List<NoteModel>> getNotes() {
    return localDataSource.getNotes();
  }

  @override
  Future<void> saveNote(NoteModel note) {
    return localDataSource.saveNote(note);
  }

  @override
  Future<void> deleteNote(String id) {
    return localDataSource.deleteNote(id);
  }

  @override
  Future<void> saveNotes(List<NoteModel> notes) {
    return localDataSource.saveNotes(notes);
  }
}
