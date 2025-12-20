import 'package:books_slayer/features/books/domain/entities/book.dart';
import 'package:books_slayer/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../datasources/books_remote_data_source.dart';
import '../../../../core/errors/exceptions.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> getBooks([String category = 'fiction']);
}

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Book>>> getBooks([
    String category = 'fiction',
  ]) async {
    try {
      final remoteBooks = await remoteDataSource.getBooks(category);
      return Right(remoteBooks.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      // Fallback for demo if API fails/offline
      return Left(ServerFailure());
    }
  }
}
