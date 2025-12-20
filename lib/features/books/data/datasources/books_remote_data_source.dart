import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/book_model.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> getBooks([String category = 'fiction']);
  Future<BookModel> getBookById(String id);
  Future<void> updateBook(BookModel book);
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final http.Client client;

  BooksRemoteDataSourceImpl({required this.client});

  @override
  Future<BookModel> getBookById(String id) async {
    final response = await client.get(
      Uri.parse('https://gutendex.com/books/$id'),
    );

    if (response.statusCode == 200) {
      return BookModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<BookModel>> getBooks([String category = 'fiction']) async {
    // Search by Topic/Category
    final response = await client.get(
      Uri.parse('https://gutendex.com/books?topic=$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results
          .map((json) => BookModel.fromJson(json).copyWith(category: category))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateBook(BookModel book) async {
    // Local operation in this static version, no API post
    return;
  }
}
