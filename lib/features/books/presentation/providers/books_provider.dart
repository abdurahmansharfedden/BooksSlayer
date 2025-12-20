import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/books_remote_data_source.dart';
import '../../data/repositories/books_repository_impl.dart';
import '../../domain/entities/book.dart';

// HTTP Client Provider
final httpClientProvider = Provider((ref) => http.Client());

// Data Source Provider
final booksRemoteDataSourceProvider = Provider((ref) {
  return BooksRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

// Repository Provider
final booksRepositoryProvider = Provider((ref) {
  return BooksRepositoryImpl(
    remoteDataSource: ref.read(booksRemoteDataSourceProvider),
  );
});

// Books Future Provider (Fetches books based on category)
final booksProvider = FutureProvider.family<List<Book>, String>((
  ref,
  category,
) async {
  final repository = ref.read(booksRepositoryProvider);
  final result = await repository.getBooks(category);
  return result.fold(
    (failure) => [], // Return empty on error for now (or throw to handle in UI)
    (books) => books,
  );
});

// Featured Books Provider (Specific queries)
final featuredBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.read(booksRepositoryProvider);
  // Fetching a popular category
  final result = await repository.getBooks('best_books');
  return result.fold((l) => [], (r) => r.take(5).toList());
});
