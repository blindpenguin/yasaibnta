import 'dart:async';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class NotesDbService extends GetxService {
  static const _dbName = 'notes.db';
  static const _dbVersion = 1;

  static const tableNotes = 'notes';

  Database? _db;

  Future<NotesDbService> init() async {
    _db = await _openDb();
    return this;
  }

  Future<Database> _openDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, _dbName);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableNotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL DEFAULT '',
            content TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL,
            is_pinned INTEGER NOT NULL DEFAULT 0,
            is_archived INTEGER NOT NULL DEFAULT 0
          );
        ''');
      },
      // Simple forward-only migrations for now.
      onUpgrade: (db, oldVersion, newVersion) async {
        // No migrations yet.
      },
    );
  }

  Database get _database {
    final db = _db;
    if (db == null) {
      throw StateError('Database has not been initialized. Call init() first.');
    }
    return db;
  }

  Future<List<Note>> getAllNotes() async {
    final rows = await _database.query(
      tableNotes,
      where: 'is_archived = ?',
      whereArgs: [0],
      orderBy: 'is_pinned DESC, updated_at DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final rows = await _database.query(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Note.fromMap(rows.first);
  }

  Future<int> insertNote(Note note) async {
    final map = note.copyWith(id: null).toMap();
    return _database.insert(
      tableNotes,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateNote(Note note) async {
    if (note.id == null) {
      throw ArgumentError('Cannot update note without an id');
    }
    final map = note.toMap();
    return _database.update(
      tableNotes,
      map,
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteNote(int id) async {
    return _database.delete(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}


