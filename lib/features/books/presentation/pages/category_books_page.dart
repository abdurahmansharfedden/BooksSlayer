import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/books_provider.dart';
import '../widgets/all_books_grid.dart';

class CategoryBooksPage extends ConsumerWidget {
  final String categoryName;
  final String categoryId; // Used for API query (e.g. "fiction")

  const CategoryBooksPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider with specific category
    final booksAsyncValue = ref.watch(booksProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: booksAsyncValue.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(child: Text("No books found."));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AllBooksGrid(books: books),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text("Failed to load books: $err")),
      ),
    );
  }
}
