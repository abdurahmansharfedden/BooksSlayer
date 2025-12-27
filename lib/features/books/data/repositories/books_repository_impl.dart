import 'package:dartz/dartz.dart';
import 'package:books_slayer/core/errors/failures.dart';
import 'package:books_slayer/core/errors/exceptions.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_remote_data_source.dart';
import '../datasources/books_local_datasource.dart';
import '../models/book_model.dart';
import 'package:uuid/uuid.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;
  final BooksLocalDataSource localDataSource;

  BooksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addBook(Book book) async {
    try {
      final bookModel = BookModel(
        id: book.id.isEmpty ? const Uuid().v4() : book.id,
        title: book.title,
        author: book.author,
        imageUrl: book.imageUrl,
        rating: book.rating,
        description: book.description,
        category: book.category,
        isFavorite: book.isFavorite,
        readUrl: book.readUrl,
        downloadCount: book.downloadCount,
        userId: book.userId,
        languages: book.languages,
        subjects: book.subjects,
      );
      await localDataSource.addBook(bookModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getUserBooks(String userId) async {
    try {
      final localBooks = await localDataSource.getUserBooks(userId);
      return Right(localBooks.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure()); // Or a specific LocalStorageFailure
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Book book, String userId) async {
    try {
      final localBook = await localDataSource.getBook(book.id);

      if (localBook != null) {
        // Book exists locally, toggle favorite status
        final updatedBook = localBook.copyWith(
          isFavorite: !localBook.isFavorite,
          userId: userId, // Ensure userId is set
        );
        await localDataSource.addBook(updatedBook);
      } else {
        // Book is remote/new, add to local DB as favorite
        final newBook = BookModel(
          id: book.id,
          title: book.title,
          author: book.author,
          imageUrl: book.imageUrl,
          rating: book.rating,
          description: book.description,
          category: book.category,
          isFavorite: true,
          readUrl: book.readUrl,
          downloadCount: book.downloadCount,
          userId: userId,
          languages: book.languages,
          subjects: book.subjects,
        );
        await localDataSource.addBook(newBook);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
