import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/featured_books_widget.dart';
import '../widgets/continue_reading_widget.dart';
import '../widgets/all_books_grid.dart';
import '../widgets/add_edit_book_sheet.dart';
import '../providers/books_provider.dart';
import '../widgets/book_search_delegate.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsyncValue = ref.watch(featuredBooksProvider);
    final allBooksAsyncValue = ref.watch(booksProvider('fiction'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Books Slayer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final books = allBooksAsyncValue.asData?.value ?? [];
              showSearch(context: context, delegate: BookSearchDelegate(books));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const AddEditBookSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            featuredAsyncValue.when(
              data: (books) {
                if (books.isEmpty) return const SizedBox.shrink();
                return FeaturedBooksWidget(books: books);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Continue Reading",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            allBooksAsyncValue.when(
              data: (books) =>
                  ContinueReadingWidget(books: books.take(3).toList()),
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Books",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.grid_view),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            allBooksAsyncValue.when(
              data: (books) => AllBooksGrid(books: books),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Failed to load books')),
            ),
          ],
        ),
      ),
    );
  }
}
