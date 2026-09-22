import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/notes_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        children: [
          Text(
            'APPEARANCE',
            style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 1.5, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'DATA MANAGEMENT',
            style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 1.5, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.download_rounded, color: theme.colorScheme.primary),
                  title: const Text('Export Backup'),
                  subtitle: const Text('Export all notes as a JSON string file'),
                  onTap: () {
                    final jsonString = ref.read(notesNotifierProvider.notifier).exportNotes();
                    Share.share(jsonString, subject: 'NoteFlow Backup');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.upload_rounded, color: theme.colorScheme.primary),
                  title: const Text('Import Backup'),
                  subtitle: const Text('Restore notes from a JSON string backup'),
                  onTap: () => _showImportDialog(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'NoteFlow v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import Backup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Paste your valid NoteFlow backup JSON string below:'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '[{"id": "...", "title": "..."}]',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                final success = ref.read(notesNotifierProvider.notifier).importNotes(text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Notes imported successfully!' : 'Invalid backup JSON content'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }
}
