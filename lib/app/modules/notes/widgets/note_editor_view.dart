import 'package:flutter/material.dart';

import '../../../data/models/note_model.dart';

class NoteEditorView extends StatefulWidget {
  const NoteEditorView({
    super.key,
    required this.note,
    required this.onSave,
    required this.onDelete,
    required this.onClose,
    this.showDelete = true,
  });

  final Note note;
  final ValueChanged<Note> onSave;
  final VoidCallback onDelete;
  final VoidCallback onClose;
  final bool showDelete;

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  static const double _toolbarHeight = 40;

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void didUpdateWidget(NoteEditorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id) {
      _titleController.text = widget.note.title;
      _contentController.text = widget.note.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updated = widget.note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
    );
    widget.onSave(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _toolbarHeight,
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, _toolbarHeight),
                ),
                onPressed: _handleSave,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              if (widget.showDelete) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, _toolbarHeight),
                  ),
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ],
              const SizedBox(width: 8),
              IconButton(
                constraints: const BoxConstraints.tightFor(
                  height: _toolbarHeight,
                  width: _toolbarHeight,
                ),
                tooltip: 'Close',
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


