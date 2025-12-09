import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.totalNotes,
    required this.onCreateNote,
  });

  final int totalNotes;
  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNotes = totalNotes > 0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasNotes ? 'Notes overview' : 'Welcome to your notes',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            hasNotes
                ? 'You currently have $totalNotes notes.'
                : 'Get started by creating your first note.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateNote,
            icon: const Icon(Icons.note_add),
            label: Text(hasNotes ? 'Create new note' : 'Create your first note'),
          ),
        ],
      ),
    );
  }
}


