import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:mobileapp/core/theme/app_colors.dart';
import '../../data/models/note_model.dart';
import '../providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;

  String _category = 'Uncategorized';
  List<String> _tags = [];
  int _colorValue = 0;
  bool _isPinned = false;
  bool _isFavorite = false;
  bool _isArchived = false;
  DateTime? _reminderAt;
  DateTime? _createdAt;

  bool _isInitialLoaded = false;

  final List<String> _predefinedCategories = ['Uncategorized', 'Personal', 'Work', 'Ideas', 'Important', 'Finance'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _tagController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialLoaded) {
      if (widget.noteId != null) {
        final notes = ref.read(notesNotifierProvider);
        final noteIndex = notes.indexWhere((n) => n.id == widget.noteId);
        if (noteIndex != -1) {
          final note = notes[noteIndex];
          _titleController.text = note.title;
          _contentController.text = note.content;
          _category = note.category;
          _tags = List<String>.from(note.tags);
          _colorValue = note.colorValue;
          _isPinned = note.isPinned;
          _isFavorite = note.isFavorite;
          _isArchived = note.isArchived;
          _reminderAt = note.reminderAt;
          _createdAt = note.createdAt;
        }
      }
      _isInitialLoaded = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    if (widget.noteId == null) {
      return _titleController.text.isNotEmpty || _contentController.text.isNotEmpty || _tags.isNotEmpty || _colorValue != 0;
    } else {
      final notes = ref.read(notesNotifierProvider);
      final note = notes.firstWhere((n) => n.id == widget.noteId);
      return _titleController.text != note.title ||
          _contentController.text != note.content ||
          _category != note.category ||
          _tags.length != note.tags.length ||
          _colorValue != note.colorValue ||
          _isPinned != note.isPinned ||
          _isFavorite != note.isFavorite ||
          _isArchived != note.isArchived ||
          _reminderAt != note.reminderAt;
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = NoteModel(
        id: widget.noteId ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _category,
        tags: _tags,
        colorValue: _colorValue,
        isPinned: _isPinned,
        isFavorite: _isFavorite,
        isArchived: _isArchived,
        createdAt: _createdAt ?? now,
        updatedAt: now,
        reminderAt: _reminderAt,
      );

      final notifier = ref.read(notesNotifierProvider.notifier);
      if (widget.noteId == null) {
        notifier.addNote(note);
      } else {
        notifier.updateNote(note);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved successfully!'), duration: Duration(seconds: 1)),
      );
      context.pop();
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges()) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagController.clear();
      });
    }
  }

  Future<void> _pickReminder() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderAt ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderAt ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _reminderAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColors = isDark ? AppColors.noteColorsDark : AppColors.noteColors;
    final bgColor = bgColors[_colorValue < bgColors.length ? _colorValue : 0];

    final hasCustomBg = bgColor != Colors.transparent;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: hasCustomBg ? bgColor : theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: hasCustomBg ? bgColor : theme.appBarTheme.backgroundColor,
          title: Text(widget.noteId == null ? 'New Note' : 'Edit Note'),
          actions: [
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              color: hasCustomBg ? Colors.black87 : null,
              onPressed: () => setState(() => _isPinned = !_isPinned),
            ),
            IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              color: _isFavorite ? Colors.redAccent : (hasCustomBg ? Colors.black87 : null),
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
            ),
            IconButton(
              icon: const Icon(Icons.check),
              color: hasCustomBg ? Colors.black87 : null,
              onPressed: _saveNote,
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Category & Reminder Fields Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _predefinedCategories.contains(_category) ? _category : 'Uncategorized',
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: hasCustomBg ? Colors.white.withOpacity(0.3) : null,
                        ),
                        items: _predefinedCategories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _category = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: _pickReminder,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                          color: _reminderAt != null
                              ? theme.colorScheme.primaryContainer
                              : (hasCustomBg ? Colors.white.withOpacity(0.3) : null),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _reminderAt != null ? Icons.alarm_on : Icons.alarm_add,
                              color: _reminderAt != null ? theme.colorScheme.primary : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _reminderAt != null ? 'Reminder Set' : 'Add Reminder',
                              style: TextStyle(
                                color: _reminderAt != null ? theme.colorScheme.primary : null,
                                fontWeight: _reminderAt != null ? FontWeight.bold : null,
                              ),
                            ),
                            if (_reminderAt != null) ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => setState(() => _reminderAt = null),
                                child: const Icon(Icons.close, size: 16, color: Colors.grey),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Note Title TextField
                TextFormField(
                  controller: _titleController,
                  maxLength: 100,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: TextStyle(color: hasCustomBg ? Colors.black54 : null),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Note Content TextField
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  minLines: 8,
                  maxLength: 10000,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Start typing your note here...',
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: TextStyle(color: hasCustomBg ? Colors.black54 : null),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Content is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Color Palette Picker Label
                Text(
                  'Color Palette',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Color Palette List Horizontal
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bgColors.length,
                    itemBuilder: (context, idx) {
                      final c = bgColors[idx];
                      final isSelected = _colorValue == idx;
                      return GestureDetector(
                        onTap: () => setState(() => _colorValue = idx),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: c == Colors.transparent ? (isDark ? Colors.grey[800] : Colors.grey[200]) : c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : (c == Colors.transparent ? theme.colorScheme.outline.withOpacity(0.3) : Colors.transparent),
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: idx == 0 ? theme.colorScheme.primary : Colors.black87, size: 20)
                              : (c == Colors.transparent ? const Icon(Icons.format_color_reset, size: 16, color: Colors.grey) : null),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Tags Section Label
                Text(
                  'Tags',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Tags Input and Add Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          hintText: 'Add a tag...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: _addTag,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags Chip Wrap
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((t) {
                    return InputChip(
                      label: Text(t),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(t);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
