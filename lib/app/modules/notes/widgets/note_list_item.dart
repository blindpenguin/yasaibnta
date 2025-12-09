import 'package:flutter/material.dart';

import '../../../data/models/note_model.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
  });

  final Note note;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListTile(
      selected: isSelected,
      title: Text(
        note.title.isEmpty ? 'Untitled note' : note.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        note.content.isEmpty
            ? 'No content yet'
            : note.content.split('\n').first,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}


