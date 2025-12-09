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

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Notes overview',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'You currently have $totalNotes notes.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateNote,
            icon: const Icon(Icons.note_add),
            label: const Text('Create your first note'),
          ),
        ],
      ),
    );
  }
}


