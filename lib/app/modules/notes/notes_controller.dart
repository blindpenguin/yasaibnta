import 'package:get/get.dart';

import '../../data/models/note_model.dart';
import '../../data/services/notes_db_service.dart';

class NotesController extends GetxController {
  NotesController(this._dbService);

  final NotesDbService _dbService;

  final notes = <Note>[].obs;
  final selectedNote = Rx<Note?>(null);

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

  void selectNote(Note? note) {
    selectedNote.value = note;
  }

  Future<void> createNewNote() async {
    final now = DateTime.now();
    final note = Note(
      title: '',
      content: '',
      createdAt: now,
      updatedAt: now,
    );
    final id = await _dbService.insertNote(note);
    final created = note.copyWith(id: id);
    notes.insert(0, created);
    selectedNote.value = created;
  }

  Future<void> saveNote(Note updated) async {
    final now = DateTime.now();
    final toSave = updated.copyWith(updatedAt: now);
    if (toSave.id == null) {
      final id = await _dbService.insertNote(toSave);
      final created = toSave.copyWith(id: id);
      notes.insert(0, created);
      selectedNote.value = created;
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
  }

  Future<void> deleteSelectedNote() async {
    final current = selectedNote.value;
    if (current == null || current.id == null) return;
    await _dbService.deleteNote(current.id!);
    notes.removeWhere((n) => n.id == current.id);
    selectedNote.value = null;
  }
}


