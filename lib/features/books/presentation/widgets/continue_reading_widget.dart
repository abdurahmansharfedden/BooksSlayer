import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../pages/book_details_page.dart';

class ContinueReadingWidget extends StatelessWidget {
  final List<Book> books;
  const ContinueReadingWidget({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.only(right: 16, bottom: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailsPage(
                      book: book,
                      heroTag: 'continue_${book.id}',
                    ),
                  ),
                );
              },
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Mini Cover
                    Container(
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            book.author,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: 0.65, // Fake progress
                            backgroundColor: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "65% Completed",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
