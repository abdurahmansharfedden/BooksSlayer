import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/favorites_provider.dart';
import 'book_details_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [IconButton(icon: const Icon(Icons.sort), onPressed: () {})],
      ),
      body: favoriteBooks.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: book.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(book.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: book.imageUrl == null
                          ? const Icon(Icons.book)
                          : null,
                    ),
                    title: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(book.author),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(book);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailsPage(
                            book: book,
                            heroTag: 'favorite_${book.id}',
                          ),
                        ),
                      );
                    },
                  ),
                ).animate().fadeIn(delay: (50 * index).ms).slideX();
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[300])
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 1.seconds,
              ),
          const SizedBox(height: 20),
          Text(
            "No favorites yet",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "Start measuring your library by adding books.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
