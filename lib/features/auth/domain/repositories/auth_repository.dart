import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  });
}
