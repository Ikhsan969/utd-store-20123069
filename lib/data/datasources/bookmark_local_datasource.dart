// lib/data/datasources/bookmark_local_datasource.dart
// Menggunakan sqflite + StreamController untuk reactive stream
// Menggantikan Isar yang tidak kompatibel dengan AGP baru

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bookmark_model.dart';
import '../../domain/entities/bookmark_entity.dart';

class BookmarkLocalDataSource {
  static Database? _database;
  // ⭐ StreamController untuk reactive - menggantikan watch() dari Isar
  final _bookmarkStreamController =
      StreamController<List<BookmarkEntity>>.broadcast();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'utd_store_bookmarks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER UNIQUE NOT NULL,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            image TEXT NOT NULL,
            savedAt INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Emit ulang data terbaru ke stream
  Future<void> _notifyListeners() async {
    final bookmarks = await _getAllBookmarks();
    _bookmarkStreamController.add(bookmarks);
  }

  Future<List<BookmarkEntity>> _getAllBookmarks() async {
    final db = await database;
    final maps = await db.query('bookmarks', orderBy: 'savedAt DESC');
    return maps.map((m) => BookmarkModel.fromMap(m).toEntity()).toList();
  }

  Future<void> addBookmark(BookmarkEntity entity) async {
    final db = await database;
    final model = BookmarkModel.fromEntity(entity);
    await db.insert(
      'bookmarks',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _notifyListeners(); // ⭐ Update stream setelah insert
  }

  Future<void> removeBookmark(int productId) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    await _notifyListeners(); // ⭐ Update stream setelah delete
  }

  // ⭐ REACTIVE STREAM - menggantikan watch() Isar
  Stream<List<BookmarkEntity>> watchBookmarks() {
    // Fire immediately dengan data saat ini
    _getAllBookmarks().then((data) => _bookmarkStreamController.add(data));
    return _bookmarkStreamController.stream;
  }

  Future<bool> isBookmarked(int productId) async {
    final db = await database;
    final result = await db.query(
      'bookmarks',
      where: 'productId = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  void dispose() {
    _bookmarkStreamController.close();
  }
}
