import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../domain/entities/book.dart';
import '../pages/book_details_page.dart';

class FeaturedBooksWidget extends StatefulWidget {
  final List<Book> books;
  const FeaturedBooksWidget({super.key, required this.books});

  @override
  State<FeaturedBooksWidget> createState() => _FeaturedBooksWidgetState();
}

class _FeaturedBooksWidgetState extends State<FeaturedBooksWidget> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No featured books")),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.books.length,
          itemBuilder: (context, index, realIndex) {
            final book = widget.books[index];
            return _buildBookCard(context, book);
          },
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.6,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _activeIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _activeIndex,
          count: widget.books.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    final heroTag = 'featured_${book.id}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailsPage(book: book, heroTag: heroTag),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Placeholder (or NetworkImage)
            Hero(
              tag: heroTag,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: book.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(book.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: book.imageUrl == null
                    ? const Icon(Icons.book, size: 50)
                    : null,
              ),
            ),
            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  book.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
