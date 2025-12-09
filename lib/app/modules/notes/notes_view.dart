import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/note_model.dart';
import 'notes_controller.dart';
import 'widgets/dashboard_view.dart';
import 'widgets/note_editor_view.dart';
import 'widgets/note_reader_view.dart';
import 'widgets/note_list_item.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({super.key});

  void _confirmDeleteNote() {
    if (!controller.hasSelection) return;

    Get.defaultDialog(
      title: 'Delete note',
      middleText: 'Are you sure you want to delete this note? This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      onConfirm: () {
        controller.deleteSelectedNote();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Left: toolbar + list
          SizedBox(
            width: 320,
            child: Column(
              children: [
                _NotesToolbar(controller: controller),
                const Divider(height: 1),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.notes.length,
                      itemBuilder: (context, index) {
                        final note = controller.notes[index];
                        final isSelected =
                            controller.selectedNote.value?.id == note.id;
                        return NoteListItem(
                          note: note,
                          isSelected: isSelected,
                          onTap: () => controller.selectNote(note),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 1,
            color: theme.dividerColor,
          ),
          // Right: dashboard, reader, or editor
          Expanded(
            child: Obx(
              () {
                final Note? selected = controller.selectedNote.value;
                if (selected == null) {
                  return DashboardView(
                    totalNotes: controller.notes.length,
                    onCreateNote: controller.createNewNote,
                  );
                }
                if (controller.isEditing.value) {
                  return NoteEditorView(
                    note: selected,
                    onSave: controller.saveNote,
                    onDelete: _confirmDeleteNote,
                    onClose: controller.cancelEditing,
                    showDelete: !controller.isCreatingNew.value,
                  );
                }
                return NoteReaderView(
                  note: selected,
                  onEdit: controller.startEditing,
                  onDelete: _confirmDeleteNote,
                  onClose: controller.closeSelection,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesToolbar extends StatelessWidget {
  const _NotesToolbar({required this.controller});

  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          FilledButton.icon(
            onPressed: controller.createNewNote,
            icon: const Icon(Icons.note_add),
            label: const Text('New note'),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Placeholder for future tools (e.g., sort/filter).
            },
            tooltip: 'More tools coming soon',
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}


