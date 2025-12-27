import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/books_local_datasource.dart';

final booksLocalDataSourceProvider = Provider<BooksLocalDataSource>((ref) {
  return BooksLocalDataSourceImpl(
    databaseHelper: ref.read(databaseHelperProvider),
  );
});
