import 'package:flutter/material.dart';

import '../../../data/models/note_model.dart';

class NoteReaderView extends StatelessWidget {
  const NoteReaderView({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
  });

  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final created = note.createdAt;
    final updated = note.updatedAt;
    final createdStr =
        '${created.year.toString().padLeft(4, '0')}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}';
    final updatedStr =
        '${updated.year.toString().padLeft(4, '0')}-${updated.month.toString().padLeft(2, '0')}-${updated.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  note.title.isEmpty ? 'Untitled note' : note.title,
                  style: textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Close',
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Updated: $updatedStr • Created: $createdStr',
            style: textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Divider(height: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: SelectableText(
                note.content.isEmpty ? 'No content yet.' : note.content,
                style: textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


