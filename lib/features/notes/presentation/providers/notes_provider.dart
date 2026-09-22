import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/datasources/note_local_data_source.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../domain/repositories/note_repository.dart';

// Providers for Data Layer
final notesBoxProvider = Provider<Box<NoteModel>>((ref) {
  return Hive.box<NoteModel>('notes_box');
});

final noteLocalDataSourceProvider = Provider<NoteLocalDataSource>((ref) {
  final box = ref.watch(notesBoxProvider);
  return NoteLocalDataSourceImpl(box);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final dataSource = ref.watch(noteLocalDataSourceProvider);
  return NoteRepositoryImpl(dataSource);
});

// State Management for Notes List
class NotesNotifier extends StateNotifier<List<NoteModel>> {
  final NoteRepository _repository;
  NoteModel? _lastDeletedNote;
  int? _lastDeletedIndex;

  NotesNotifier(this._repository) : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final notes = await _repository.getNotes();
      state = notes;
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
  }

  Future<void> addNote(NoteModel note) async {
    state = [...state, note];
    await _repository.saveNote(note);
  }

  Future<void> updateNote(NoteModel note) async {
    state = [
      for (final n in state)
        if (n.id == note.id) note else n
    ];
    await _repository.saveNote(note);
  }

  Future<void> deleteNote(String id) async {
    final index = state.indexWhere((n) => n.id == id);
    if (index != -1) {
      _lastDeletedNote = state[index];
      _lastDeletedIndex = index;
      state = state.where((n) => n.id != id).toList();
      await _repository.deleteNote(id);
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedNote != null && _lastDeletedIndex != null) {
      final noteToRestore = _lastDeletedNote!;
      final indexToRestore = _lastDeletedIndex!;

      final list = List<NoteModel>.from(state);
      if (indexToRestore >= list.length) {
        list.add(noteToRestore);
      } else {
        list.insert(indexToRestore, noteToRestore);
      }
      state = list;
      await _repository.saveNote(noteToRestore);

      _lastDeletedNote = null;
      _lastDeletedIndex = null;
    }
  }

  Future<void> togglePin(String id) async {
    final note = state.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
    await updateNote(updated);
  }

  Future<void> toggleFavorite(String id) async {
    final note = state.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isFavorite: !note.isFavorite, updatedAt: DateTime.now());
    await updateNote(updated);
  }

  Future<void> toggleArchive(String id) async {
    final note = state.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isArchived: !note.isArchived, updatedAt: DateTime.now());
    await updateNote(updated);
  }

  String exportNotes() {
    final listJson = state.map((n) => n.toJson()).toList();
    return jsonEncode(listJson);
  }

  bool importNotes(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return false;

      final List<NoteModel> importedList = [];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) return false;
        // Basic fields validation
        if (item['id'] == null || item['title'] == null || item['content'] == null) return false;
        importedList.add(NoteModel.fromJson(item));
      }

      if (importedList.isNotEmpty) {
        state = [...state, ...importedList];
        _repository.saveNotes(importedList);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error importing notes: $e');
      return false;
    }
  }
}

final notesNotifierProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return NotesNotifier(repository);
});

// UI Filter/Sort State Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String>((ref) => 'All');
final tagFilterProvider = StateProvider<String?>((ref) => null);
final statusFilterProvider = StateProvider<String>((ref) => 'All'); // All, Pinned, Favorites, Archived
final sortOptionProvider = StateProvider<String>((ref) => 'Recently Updated'); // Recently Updated, Recently Created, Alphabetical, Oldest First

// Filtered Notes Provider combining search, category, tag, status, and sort
final filteredNotesProvider = Provider<List<NoteModel>>((ref) {
  final notes = ref.watch(notesNotifierProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(categoryFilterProvider);
  final tag = ref.watch(tagFilterProvider);
  final status = ref.watch(statusFilterProvider);
  final sortBy = ref.watch(sortOptionProvider);

  var result = notes;

  // Filter by status (If not explicitly looking at 'Archived', exclude archived notes from general lists)
  if (status == 'Archived') {
    result = result.where((n) => n.isArchived).toList();
  } else {
    result = result.where((n) => !n.isArchived).toList();
    if (status == 'Pinned') {
      result = result.where((n) => n.isPinned).toList();
    } else if (status == 'Favorites') {
      result = result.where((n) => n.isFavorite).toList();
    }
  }

  // Filter by category
  if (category != 'All') {
    result = result.where((n) => n.category == category).toList();
  }

  // Filter by tag
  if (tag != null && tag.isNotEmpty) {
    result = result.where((n) => n.tags.contains(tag)).toList();
  }

  // Filter by search query
  if (query.isNotEmpty) {
    result = result.where((n) =>
        n.title.toLowerCase().contains(query) ||
        n.content.toLowerCase().contains(query) ||
        n.category.toLowerCase().contains(query) ||
        n.tags.any((t) => t.toLowerCase().contains(query))).toList();
  }

  // Sort notes
  if (sortBy == 'Recently Updated') {
    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  } else if (sortBy == 'Recently Created') {
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  } else if (sortBy == 'Alphabetical') {
    result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  } else if (sortBy == 'Oldest First') {
    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  return result;
});

// Settings / Theme State Management
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
