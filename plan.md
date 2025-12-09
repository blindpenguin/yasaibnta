## App Overview

This project will be a **note taking app** built with **Flutter + GetX**, using **SQLite** as the local data store.

- **Left side**: list of notes (with basic metadata).
- **Right side**: note content editor/viewer for the selected note.
- **Dashboard state**: when no note is selected, the right side shows a dashboard instead of a note.

The first milestone is a clean, stable **offline-only** app with solid architecture that can be extended later (tags, search, sync, etc.).

## Tech Stack & Dependencies

- **Flutter**: stable channel (exact version per local setup).
- **State management & routing**: `get` (GetX).
- **Local database**:
  - `sqflite` (or `sqflite_common_ffi` for desktop if needed).
  - `path` / `path_provider` for DB file location.
- **Optional utilities** (later):
  - `intl` for date formatting.
  - `flutter_secure_storage` only if we ever store sensitive data.

## Core Features (MVP)

- **Notes**
  - Create a new note.
  - Edit note title and body.
  - Auto-update `updatedAt` when saving.
  - Soft delete or permanently delete a note (decide in implementation; start with hard delete for simplicity).

- **List panel (left)**
  - Display list of all non-deleted notes.
  - Show title, first line of content (preview), and last updated timestamp.
  - Indicate which note is currently selected.

- **Detail panel / Dashboard (right)**
  - When a note is selected: show an editor (title + multiline content).
  - When **no note is selected**: show a **dashboard** with:
    - Total number of notes.
    - Recently updated notes (e.g., last 3–5).
    - Quick actions: “New note”, maybe “Open last note”.

## Data Model & Database

- **Table: `notes`**
  - `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
  - `title` (TEXT, not null, can be empty string)
  - `content` (TEXT, not null, default empty)
  - `created_at` (INTEGER, unix timestamp)
  - `updated_at` (INTEGER, unix timestamp)
  - `is_pinned` (INTEGER, 0/1, default 0) — for future sorting.
  - `is_archived` (INTEGER, 0/1, default 0) — for future filtering.

- **SQLite layer responsibilities**
  - Initialize DB (create tables and handle simple migrations).
  - CRUD operations:
    - `insertNote`, `updateNote`, `deleteNote`, `getNoteById`, `getAllNotes`.
  - Use **parameterized queries** (no string interpolation of user content).

## Architecture & GetX Structure

- **High-level structure (under `lib/`)**
  - `app/`
    - `data/`
      - `models/` → `note_model.dart`
      - `services/` or `db/` → `notes_db_service.dart` (SQLite wrapper as a `GetxService`)
      - `repositories/` → `notes_repository.dart` (optional layer between controller and DB).
    - `modules/notes/`
      - `notes_view.dart` (main split view: list + detail/dashboard).
      - `notes_controller.dart` (GetxController managing list, selection, and editing state).
      - `notes_binding.dart` (register controller + DB service/repository).
      - `widgets/` → smaller pieces (note list item, dashboard widget, editor widgets).
    - `routes/`
      - `app_pages.dart`, `app_routes.dart` (even if we start with a single route).

- **GetX responsibilities**
  - `NotesController`
    - Holds `RxList<Note>` for the notes.
    - Holds `Rx<Note?> selectedNote`.
    - Methods:
      - `loadNotes()`
      - `selectNote(Note? note)` — `null` means “show dashboard”.
      - `createNewNote()`
      - `saveNote(Note note)` (create or update).
      - `deleteNote(Note note)`.
    - Handles simple UI-related business rules (sorting, filtering, selection).
  - `NotesDbService` (extends `GetxService`)
    - Owns `Database` instance.
    - Provides async methods for note CRUD.
    - Initialized in app startup via bindings (`Get.putAsync`).

## UI & Layout Plan

- **Main layout (desktop-focused)**
  - Fixed split view using `Row`:
    - Left: note list panel.
    - Right: detail/dashboard panel.
  - Left side:
    - Optional search field (can be added later).
    - **Toolbar above the note list** with buttons:
      - “New note” (primary action).
      - Placeholder space for future tools (filter, sort, etc.).
    - List of notes with `ListView.builder`, indicating the selected note.
  - Right side:
    - If `selectedNote == null`: dashboard widget.
    - Else: note editor with:
      - `TextField` for title.
      - `TextField` (multiline) for content.
      - Basic actions: Save, Delete (maybe auto-save on change later).

## KISS & Code Quality Guidelines (for this app)

- Keep controllers focused; avoid mixing heavy DB logic into widgets.
- Avoid over-engineering: start with a single feature module (`notes`) and one controller.
- Prefer **simple, explicit flows** over complex abstractions (e.g., no generic repositories until really needed).
- Keep widgets small and reusable where it improves readability (list item, dashboard card, etc.).
- Use `final` and `const` where possible to improve readability and performance.

## Security & Data Safety Considerations

- Use **HTTPS** for any future network features; currently this is **offline-only**.
- Use **parameterized queries** with `sqflite` to avoid SQL injection and malformed queries.
- Do not store secrets, tokens, or personal data beyond note content itself; if added later, consider `flutter_secure_storage`.
- Validate and sanitize any data that might eventually come from external sources (e.g., imports, sync).
- Avoid logging full note contents in production logs; log IDs and meta instead if needed.

## Implementation Milestones

1. **Scaffold project**
   - Create Flutter project, add `get`, `sqflite`, `path`, `path_provider`.
   - Set up `GetMaterialApp` with routes.
2. **Database layer**
   - Implement `NotesDbService` with table creation and basic CRUD.
3. **Model & controller**
   - Implement `Note` model.
   - Implement `NotesController` with loading, selection, create, save, delete logic.
4. **UI: split view + dashboard**
   - Build desktop-oriented split view with left list + toolbar and right detail/dashboard.
   - Wire up GetX (`Obx`) to drive list, selection, and editor.
5. **Polish & testing**
   - Add basic error handling (snackbars on DB errors).
   - Test core flows: create, edit, delete, select/deselect notes, dashboard display.


