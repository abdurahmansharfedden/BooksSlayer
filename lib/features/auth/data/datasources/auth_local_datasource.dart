import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> signUp(UserModel user);
  Future<UserModel?> signIn(String email, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper databaseHelper;

  AuthLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<UserModel> signUp(UserModel user) async {
    final db = await databaseHelper.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}
