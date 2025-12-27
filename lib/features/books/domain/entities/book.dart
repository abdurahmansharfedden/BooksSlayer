import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? imageUrl;
  final double rating;
  final String? description;
  final String category;
  final bool isFavorite;
  final String? readUrl;
  final int downloadCount;
  final List<String> languages;
  final List<String> subjects;
  final String? userId;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.imageUrl,
    this.rating = 0.0,
    this.description,
    required this.category,
    this.isFavorite = false,
    this.readUrl,
    this.downloadCount = 0,
    this.languages = const [],
    this.subjects = const [],
    this.userId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    imageUrl,
    rating,
    description,
    category,
    isFavorite,
    readUrl,
    downloadCount,
    languages,
    subjects,
    userId,
  ];
}
