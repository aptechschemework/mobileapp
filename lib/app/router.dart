import 'package:go_router/go_router.dart';
import '../features/notes/presentation/screens/home_screen.dart';
import '../features/notes/presentation/screens/note_detail_screen.dart';
import '../features/notes/presentation/screens/note_editor_screen.dart';
import '../features/notes/presentation/screens/search_screen.dart';
import '../features/notes/presentation/screens/favorites_screen.dart';
import '../features/notes/presentation/screens/archive_screen.dart';
import '../features/notes/presentation/screens/settings_screen.dart';
import '../features/notes/presentation/screens/reminders_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoteDetailScreen(noteId: id);
      },
    ),
    GoRoute(
      path: '/editor',
      builder: (context, state) {
        final id = state.uri.queryParameters['id'];
        return NoteEditorScreen(noteId: id);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/archive',
      builder: (context, state) => const ArchiveScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/reminders',
      builder: (context, state) => const RemindersScreen(),
    ),
  ],
);
