import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import 'books_provider.dart';

class FavoritesNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    final userBooksAsync = ref.watch(userBooksProvider);
    return userBooksAsync.maybeWhen(
      data: (books) => books.where((b) => b.isFavorite).toList(),
      orElse: () => [],
    );
  }

  Future<void> toggleFavorite(Book book) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final useCase = ref.read(toggleFavoriteUseCaseProvider);
    await useCase(book, user.id);

    // Refresh user books to reflect changes in UI
    ref.invalidate(userBooksProvider);
  }

  bool isFavorite(String bookId) {
    return state.any((b) => b.id == bookId);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Book>>(() {
  return FavoritesNotifier();
});
