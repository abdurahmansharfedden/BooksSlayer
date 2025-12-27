import 'package:books_slayer/features/books/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    super.imageUrl,
    super.rating,
    super.description,
    required super.category,
    super.isFavorite,
    super.readUrl,
    super.downloadCount,
    super.languages,
    super.subjects,
    super.userId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // Gutendex parsing
    // Parsing authors
    String author = 'Unknown Author';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      author = json['authors'][0]['name'] ?? 'Unknown';
      if (author.contains(',')) {
        final parts = author.split(',');
        if (parts.length >= 2) {
          author = '${parts[1].trim()} ${parts[0].trim()}';
        }
      }
    }

    // Paring Image
    String? imageUrl;
    if (json['formats'] != null) {
      imageUrl = json['formats']['image/jpeg'];
    }

    // Parsing Read URL
    String? readUrl;
    if (json['formats'] != null) {
      readUrl =
          json['formats']['text/html'] ??
          json['formats']['text/html; charset=utf-8'] ??
          json['formats']['text/plain'];
    }

    return BookModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? 'No Title',
      author: author,
      imageUrl: imageUrl,
      // Gutendex doesn't have ratings, we simulate it based on download_count or just random/fixed
      rating: ((json['download_count'] as num? ?? 0) / 1000)
          .clamp(3.0, 5.0)
          .toDouble(),
      description: (json['subjects'] as List?)?.join(', ') ?? 'No description',
      category: 'General',
      isFavorite: false,
      readUrl: readUrl,
      downloadCount: json['download_count'] as int? ?? 0,
      languages:
          (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? [],
      subjects:
          (json['subjects'] as List?)?.map((e) => e.toString()).toList() ?? [],
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
      'category': category,
      'isFavorite': isFavorite,
      'readUrl': readUrl,
      'download_count': downloadCount,
      'languages': languages,
      'subjects': subjects,
      'userId': userId,
    };
  }

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      imageUrl: imageUrl,
      rating: rating,
      description: description,
      category: category,
      isFavorite: isFavorite,
      readUrl: readUrl,
      downloadCount: downloadCount,
      languages: languages,
      subjects: subjects,
      userId: userId,
    );
  }

  BookModel copyWith({String? category, String? userId, bool? isFavorite}) {
    return BookModel(
      id: id,
      title: title,
      author: author,
      imageUrl: imageUrl,
      rating: rating,
      description: description,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      readUrl: readUrl,
      downloadCount: downloadCount,
      languages: languages,
      subjects: subjects,
      userId: userId ?? this.userId,
    );
  }
}
