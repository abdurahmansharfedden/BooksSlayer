import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';

class FavoritesNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    return [];
  }

  void toggleFavorite(Book book) {
    if (state.any((b) => b.id == book.id)) {
      state = state.where((b) => b.id != book.id).toList();
    } else {
      state = [...state, book];
    }
  }

  bool isFavorite(String bookId) {
    return state.any((b) => b.id == bookId);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Book>>(() {
  return FavoritesNotifier();
});
