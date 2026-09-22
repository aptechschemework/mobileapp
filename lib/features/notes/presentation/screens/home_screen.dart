import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/core/theme/app_colors.dart';
import '../providers/notes_provider.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredNotes = ref.watch(filteredNotesProvider);
    final allNotes = ref.watch(notesNotifierProvider);
    final currentCategory = ref.watch(categoryFilterProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Extract all unique categories
    final categories = ['All', ...{for (var n in allNotes) n.category}];

    // Pinned notes from current filtered list (or all pinned)
    final pinnedNotes = filteredNotes.where((n) => n.isPinned).toList();
    final ordinaryNotes = filteredNotes.where((n) => !n.isPinned).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              'NoteFlow',
              style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.push('/favorites'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              context.push(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '/archive', child: Text('Archive')),
              const PopupMenuItem(value: '/reminders', child: Text('Reminders')),
              const PopupMenuItem(value: '/settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Category list
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((cat) {
                  final isSelected = currentCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      onSelected: (_) {
                        ref.read(categoryFilterProvider.notifier).state = cat;
                      },
                      selectedColor: theme.colorScheme.primaryContainer,
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Main Notes Content
          Expanded(
            child: filteredNotes.isEmpty
                ? const EmptyState(
                    icon: Icons.note_alt_outlined,
                    title: 'No notes found',
                    subtitle: 'Create your first note or change filters to get started!',
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (pinnedNotes.isNotEmpty) ...[
                        Text(
                          'PINNED',
                          style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: pinnedNotes.length,
                          itemBuilder: (context, idx) {
                            final note = pinnedNotes[idx];
                            return _NoteCard(note: note, isDark: isDark);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (ordinaryNotes.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ALL NOTES',
                              style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
                            ),
                            IconButton(
                              icon: const Icon(Icons.sort_rounded),
                              onPressed: () => _showSortBottomSheet(context, ref),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: ordinaryNotes.length,
                          itemBuilder: (context, idx) {
                            final note = ordinaryNotes[idx];
                            return _NoteCard(note: note, isDark: isDark);
                          },
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/editor'),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showSortBottomSheet(BuildContext context, WidgetRef ref) {
    final currentSort = ref.read(sortOptionProvider);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    'Sort By',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _sortTile(context, ref, 'Recently Updated', currentSort),
                _sortTile(context, ref, 'Recently Created', currentSort),
                _sortTile(context, ref, 'Alphabetical', currentSort),
                _sortTile(context, ref, 'Oldest First', currentSort),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortTile(BuildContext context, WidgetRef ref, String option, String current) {
    return ListTile(
      title: Text(option),
      trailing: option == current ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
      onTap: () {
        ref.read(sortOptionProvider.notifier).state = option;
        Navigator.pop(context);
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  final dynamic note;
  final bool isDark;

  const _NoteCard({required this.note, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  if (note.isPinned)
                    Icon(Icons.push_pin, size: 16, color: hasCustomBg ? Colors.black87 : theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: hasCustomBg ? Colors.black87 : theme.textTheme.titleMedium?.color,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM d').format(note.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: hasCustomBg ? Colors.black54 : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                  if (note.isFavorite)
                    const Icon(Icons.favorite, size: 14, color: Colors.redAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
