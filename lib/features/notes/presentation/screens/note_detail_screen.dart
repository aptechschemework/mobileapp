import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobileapp/core/theme/app_colors.dart';
import '../providers/notes_provider.dart';

class NoteDetailScreen extends ConsumerWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesNotifierProvider);
    final noteIndex = notes.indexWhere((n) => n.id == noteId);

    if (noteIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Note Details')),
        body: const Center(child: Text('Note not found')),
      );
    }

    final note = notes[noteIndex];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColors = isDark ? AppColors.noteColorsDark : AppColors.noteColors;
    final bgColor = bgColors[note.colorValue < bgColors.length ? note.colorValue : 0];
    final hasCustomBg = bgColor != Colors.transparent;

    return Scaffold(
      backgroundColor: hasCustomBg ? bgColor : theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: hasCustomBg ? bgColor : theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            color: hasCustomBg ? Colors.black87 : null,
            onPressed: () => ref.read(notesNotifierProvider.notifier).togglePin(note.id),
          ),
          IconButton(
            icon: Icon(note.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: note.isFavorite ? Colors.redAccent : (hasCustomBg ? Colors.black87 : null),
            onPressed: () => ref.read(notesNotifierProvider.notifier).toggleFavorite(note.id),
          ),
          IconButton(
            icon: Icon(note.isArchived ? Icons.unarchive : Icons.archive_outlined),
            color: hasCustomBg ? Colors.black87 : null,
            onPressed: () {
              ref.read(notesNotifierProvider.notifier).toggleArchive(note.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(note.isArchived ? 'Note unarchived' : 'Note archived'),
                  duration: const Duration(seconds: 2),
                ),
              );
              context.pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: hasCustomBg ? Colors.black87 : null,
            onPressed: () {
              Share.share('${note.title}\n\n${note.content}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: hasCustomBg ? Colors.black87 : null,
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final notifier = ref.read(notesNotifierProvider.notifier);
              context.pop(); // Go back first
              await notifier.deleteNote(note.id);
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: const Text('Note deleted'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      notifier.undoDelete();
                    },
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category tag and Date row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (hasCustomBg ? Colors.white : theme.colorScheme.primaryContainer).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      note.category,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    'Updated ${DateFormat('MMM d, h:mm a').format(note.updatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: hasCustomBg ? Colors.black54 : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: hasCustomBg ? Colors.black87 : theme.textTheme.displayLarge?.color,
                ),
              ),
              const SizedBox(height: 16),

              // Tags
              if (note.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.tags.map((tag) {
                    return Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 12)),
                      backgroundColor: hasCustomBg ? Colors.white.withOpacity(0.5) : null,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Reminder Info if any
              if (note.reminderAt != null) ...[
                Row(
                  children: [
                    Icon(Icons.alarm, size: 16, color: hasCustomBg ? Colors.black54 : theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Reminder: ${DateFormat('MMM d, h:mm a').format(note.reminderAt!)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              const Divider(height: 1),
              const SizedBox(height: 16),

              // Content Body
              Text(
                note.content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: hasCustomBg ? Colors.black87 : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hasCustomBg ? Colors.black87 : theme.floatingActionButtonTheme.backgroundColor,
        foregroundColor: hasCustomBg ? Colors.white : theme.floatingActionButtonTheme.foregroundColor,
        onPressed: () => context.push('/editor?id=${note.id}'),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
