import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/book_model.dart';

abstract class BooksLocalDataSource {
  Future<void> cacheBooks(List<BookModel> books);
  Future<List<BookModel>> getLastBooks();
  Future<void> addBook(BookModel book);
  Future<List<BookModel>> getUserBooks(String userId);
  Future<BookModel?> getBook(String id);
}

class BooksLocalDataSourceImpl implements BooksLocalDataSource {
  final DatabaseHelper databaseHelper;

  BooksLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheBooks(List<BookModel> books) async {
    // Not implemented for now, preserving existing cache logic if needed,
    // but for this task we focus on user books.
  }

  @override
  Future<List<BookModel>> getLastBooks() async {
    // Not implemented for now
    return [];
  }

  @override
  Future<void> addBook(BookModel book) async {
    final db = await databaseHelper.database;
    // We need to flatten the list fields for SQLite or ignore them if not essential for local library
    // For simplicity, we'll store basic fields and JSON encode complex ones if needed,
    // or just rely on what schema we created.
    // The schema was: id, title, author, imageUrl, description, rating, category, userId, isFavorite

    await db.insert('books', {
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'imageUrl': book.imageUrl,
      'description': book.description,
      'rating': book.rating,
      'category': book.category,
      'userId': book.userId,
      'isFavorite': book.isFavorite ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<BookModel>> getUserBooks(String userId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        imageUrl: maps[i]['imageUrl'],
        description: maps[i]['description'],
        rating: maps[i]['rating'],
        category: maps[i]['category'],
        userId: maps[i]['userId'],
        isFavorite: maps[i]['isFavorite'] == 1,
        // Defaulting list fields as they aren't in schema yet
        languages: const [],
        subjects: const [],
        downloadCount: 0,
      );
    });
  }

  @override
  Future<BookModel?> getBook(String id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return BookModel(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        imageUrl: map['imageUrl'],
        description: map['description'],
        rating: map['rating'],
        category: map['category'],
        userId: map['userId'],
        isFavorite: map['isFavorite'] == 1,
        languages: const [],
        subjects: const [],
        downloadCount: 0,
      );
    }
    return null;
  }
}
