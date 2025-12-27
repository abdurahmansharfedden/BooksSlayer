import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class GetBooksUseCase {
  final BooksRepository repository;

  GetBooksUseCase(this.repository);

  Future<Either<Failure, List<Book>>> call([String category = 'fiction']) {
    return repository.getBooks(category);
  }
}

class AddBookUseCase {
  final BooksRepository repository;

  AddBookUseCase(this.repository);

  Future<Either<Failure, void>> call(Book book) {
    return repository.addBook(book);
  }
}

class GetUserBooksUseCase {
  final BooksRepository repository;

  GetUserBooksUseCase(this.repository);

  Future<Either<Failure, List<Book>>> call(String userId) {
    return repository.getUserBooks(userId);
  }
}
