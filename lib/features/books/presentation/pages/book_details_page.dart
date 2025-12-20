import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/book.dart';
import 'book_reader_page.dart';
import '../providers/favorites_provider.dart';

class BookDetailsPage extends ConsumerWidget {
  final Book book;
  final Object? heroTag;

  const BookDetailsPage({super.key, required this.book, this.heroTag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch favorites to see if this book is in the list
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.any((b) => b.id == book.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(book);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav ? "Removed from Favorites" : "Added to Favorites",
                  ),
                  duration: 500.ms,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.share,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header with Cover
            _buildHeader(context, theme),

            // Content
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Author
                    Text(
                      book.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn().moveY(begin: 10, end: 0),

                    const SizedBox(height: 8),

                    Text(
                      book.author,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ).animate().fadeIn(delay: 100.ms).moveY(begin: 10, end: 0),

                    const SizedBox(height: 20),

                    // Stats Row
                    _buildStatsRow(context),

                    const SizedBox(height: 20),

                    // Tags / Subjects
                    if (book.subjects.isNotEmpty) ...[
                      Text(
                        "Tags",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: book.subjects.take(5).map((subject) {
                          // Clean up subject string (often "Science Fiction -- History")
                          final label = subject.split('--').last.trim();
                          return Chip(
                            label: Text(
                              label,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: theme.colorScheme.secondary
                                .withValues(alpha: 0.2),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Description
                    Text(
                      "Description",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.subjects.isNotEmpty
                          ? book.subjects.join(
                              ', ',
                            ) // Fallback as Gutendex uses subjects
                          : (book.description ?? "No description available."),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookReaderPage(book: book),
                                ),
                              );
                            },
                            icon: const Icon(FontAwesomeIcons.bookOpen),
                            label: const Text("Read Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {}, // Edit Action
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: theme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Stack(
      children: [
        // Blurred Background
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: book.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(book.imageUrl!),
                    fit: BoxFit.cover,
                    opacity: 0.4,
                  )
                : null,
            color: book.imageUrl == null
                ? theme.primaryColor.withValues(alpha: 0.2)
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.scaffoldBackgroundColor,
                  Colors.transparent,
                  Colors.black54,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        // Hero Image
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Hero(
              tag: heroTag ?? 'book_cover_${book.id}',
              child: Container(
                width: 160,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: book.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(book.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey[300],
                ),
                child: book.imageUrl == null
                    ? const Icon(Icons.book, size: 50)
                    : null,
              ),
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          context,
          'Rating',
          '${book.rating.toStringAsFixed(1)} ⭐',
        ),
        _buildStatItem(context, 'Downloads', '${book.downloadCount}'),
        _buildStatItem(
          context,
          'Language',
          book.languages.isNotEmpty
              ? book.languages.first.toUpperCase()
              : 'ENG',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}
