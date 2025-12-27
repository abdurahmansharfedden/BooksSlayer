import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/books_remote_data_source.dart';
import '../../data/repositories/books_repository_impl.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'books_local_datasource_provider.dart';
import '../../domain/usecases/book_usecases.dart';

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
    localDataSource: ref.read(booksLocalDataSourceProvider),
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

final getUserBooksUseCaseProvider = Provider((ref) {
  return GetUserBooksUseCase(ref.read(booksRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider((ref) {
  return ToggleFavoriteUseCase(ref.read(booksRepositoryProvider));
});

final userBooksProvider = FutureProvider<List<Book>>((ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return [];

  final useCase = ref.read(getUserBooksUseCaseProvider);
  final result = await useCase(user.id);

  return result.fold((failure) => [], (books) => books);
});
