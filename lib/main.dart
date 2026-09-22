import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'features/notes/data/models/note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Manual TypeAdapter
  Hive.registerAdapter(NoteModelAdapter());

  // Open the Notes Box
  await Hive.openBox<NoteModel>('notes_box');

  runApp(
    const ProviderScope(
      child: NoteFlowApp(),
    ),
  );
}
