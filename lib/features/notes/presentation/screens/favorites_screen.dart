import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/core/theme/app_colors.dart';
import '../providers/notes_provider.dart';
import '../widgets/empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allNotes = ref.watch(notesNotifierProvider);
    final favoriteNotes = allNotes.where((n) => n.isFavorite && !n.isArchived).toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteNotes.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              subtitle: 'Tap the heart icon on any note to add it here!',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: favoriteNotes.length,
              itemBuilder: (context, index) {
                final note = favoriteNotes[index];
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (hasCustomBg ? Colors.white : theme.colorScheme.primaryContainer).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    note.category,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
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
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, yyyy').format(note.updatedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: hasCustomBg ? Colors.black54 : null,
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
