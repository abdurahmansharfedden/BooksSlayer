import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books_slayer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )
    ''';

    const bookTable = '''
    CREATE TABLE books (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      author TEXT NOT NULL,
      imageUrl TEXT,
      description TEXT,
      rating REAL,
      category TEXT,
      userId TEXT NOT NULL,
      isFavorite INTEGER DEFAULT 0
    )
    ''';

    await db.execute(userTable);
    await db.execute(bookTable);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      const bookTable = '''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        imageUrl TEXT,
        description TEXT,
        rating REAL,
        category TEXT,
        userId TEXT NOT NULL,
        isFavorite INTEGER DEFAULT 0
      )
      ''';
      await db.execute(bookTable);
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
