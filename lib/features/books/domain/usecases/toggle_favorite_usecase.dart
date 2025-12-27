import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class ToggleFavoriteUseCase {
  final BooksRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(Book book, String userId) {
    return repository.toggleFavorite(book, userId);
  }
}
