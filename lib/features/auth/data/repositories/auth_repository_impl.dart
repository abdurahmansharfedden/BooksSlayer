import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final newUser = UserModel(
        id: const Uuid().v4(),
        name: name,
        email: email,
        password: password,
      );
      final user = await localDataSource.signUp(newUser);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await localDataSource.signIn(email, password);
      if (user != null) {
        return Right(user);
      } else {
        return const Left('Invalid email or password');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
