import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/core/theme/app_colors.dart';
import '../providers/notes_provider.dart';
import '../widgets/empty_state.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allNotes = ref.watch(notesNotifierProvider);
    final reminderNotes = allNotes.where((n) => n.reminderAt != null).toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Sort by reminder date ascending
    reminderNotes.sort((a, b) => a.reminderAt!.compareTo(b.reminderAt!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: reminderNotes.isEmpty
          ? const EmptyState(
              icon: Icons.alarm_off_rounded,
              title: 'No reminders set',
              subtitle: 'Add reminders inside the note editor to stay organized!',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: reminderNotes.length,
              itemBuilder: (context, index) {
                final note = reminderNotes[index];
                final bgColors = isDark ? AppColors.noteColorsDark : AppColors.noteColors;
                final bgColor = bgColors[note.colorValue < bgColors.length ? note.colorValue : 0];
                final hasCustomBg = bgColor != Colors.transparent;

                return Card(
                  color: hasCustomBg ? bgColor : theme.cardTheme.color,
                  elevation: hasCustomBg ? 0 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: hasCustomBg ? BorderSide.none : BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push('/detail/${note.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.alarm, size: 14, color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat('MMM d, h:mm a').format(note.reminderAt!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.title.isEmpty ? 'Untitled' : note.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: hasCustomBg ? Colors.black87 : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              note.content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: hasCustomBg ? Colors.black87 : theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (hasCustomBg ? Colors.white : theme.colorScheme.primaryContainer).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              note.category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
