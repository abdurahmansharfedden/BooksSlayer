import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> getBooks([String category = 'fiction']);
  Future<Either<Failure, void>> addBook(Book book);
  Future<Either<Failure, List<Book>>> getUserBooks(String userId);
  Future<Either<Failure, void>> toggleFavorite(Book book, String userId);
}
