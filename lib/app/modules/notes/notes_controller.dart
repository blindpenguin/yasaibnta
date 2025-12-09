import 'package:get/get.dart';

import '../../data/models/note_model.dart';
import '../../data/services/notes_db_service.dart';

class NotesController extends GetxController {
  NotesController(this._dbService);

  final NotesDbService _dbService;

  final notes = <Note>[].obs;
  final selectedNote = Rx<Note?>(null);
  final isEditing = false.obs;
  final isCreatingNew = false.obs;

  bool get hasSelection => selectedNote.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final allNotes = await _dbService.getAllNotes();
    notes.assignAll(allNotes);
  }

  void cancelEditing() {
    final current = selectedNote.value;
    if (current == null) return;

    // If we are on the create form, treat cancel as "discard draft".
    if (isCreatingNew.value && current.id == null) {
      selectedNote.value = null;
      isEditing.value = false;
      isCreatingNew.value = false;
      return;
    }

    // For existing notes, just go back to read-only.
    isEditing.value = false;
  }

  void closeSelection() {
    selectedNote.value = null;
    isEditing.value = false;
    isCreatingNew.value = false;
  }

  void selectNote(Note? note) {
    // Tapping the already-selected note toggles selection off.
    if (note != null && selectedNote.value?.id == note.id) {
      selectedNote.value = null;
      isEditing.value = false;
      isCreatingNew.value = false;
      return;
    }

    selectedNote.value = note;
    isCreatingNew.value = false;
    // Clicking a note should show it in read-only mode first.
    isEditing.value = false;
  }

  void startEditing() {
    if (selectedNote.value != null) {
      isEditing.value = true;
    }
  }

  Future<void> createNewNote() async {
    final now = DateTime.now();
    final note = Note(
      title: '',
      content: '',
      createdAt: now,
      updatedAt: now,
    );
    // Keep this new note as an in-memory draft until the user hits Save.
    selectedNote.value = note;
    isEditing.value = true;
    isCreatingNew.value = true;
  }

  Future<void> saveNote(Note updated) async {
    final now = DateTime.now();
    final toSave = updated.copyWith(updatedAt: now);
    if (toSave.id == null) {
      final id = await _dbService.insertNote(toSave);
      final created = toSave.copyWith(id: id);
      notes.insert(0, created);
      selectedNote.value = created;
      isCreatingNew.value = false;
    } else {
      await _dbService.updateNote(toSave);
      final index = notes.indexWhere((n) => n.id == toSave.id);
      if (index != -1) {
        notes[index] = toSave;
      }
      if (selectedNote.value?.id == toSave.id) {
        selectedNote.value = toSave;
      }
    }
    // After saving, navigate back to the note's read-only view.
    isEditing.value = false;
    isCreatingNew.value = false;
  }

  Future<void> deleteSelectedNote() async {
    final current = selectedNote.value;
    if (current == null || current.id == null) return;
    await _dbService.deleteNote(current.id!);
    notes.removeWhere((n) => n.id == current.id);
    selectedNote.value = null;
    isEditing.value = false;
    isCreatingNew.value = false;
  }
}


