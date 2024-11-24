import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Getter to retrieve database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize database
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      // Open the database
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      throw Exception('Error initializing database: $e');
    }
  }

  // Create database schema
  Future<void> _createDB(Database db, int version) async {
    const noteTable = '''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''';

    try {
      await db.execute(noteTable);
    } catch (e) {
      throw Exception('Error creating database schema: $e');
    }
  }

  // Insert a new note
  Future<int> insert(Note note) async {
    try {
      final db = await instance.database;
      return await db.insert('notes', note.toMap());
    } catch (e) {
      throw Exception('Error inserting note: $e');
    }
  }

  // Retrieve all notes
  Future<List<Note>> getNotes() async {
    try {
      final db = await instance.database;
      final result = await db.query('notes', orderBy: 'id DESC');
      return result.map((json) => Note.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Error fetching notes: $e');
    }
  }

  // Delete a note
  Future<int> delete(int id) async {
    try {
      final db = await instance.database;
      return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Error deleting note: $e');
    }
  }

  // Close the database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
