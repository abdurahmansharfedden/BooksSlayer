import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book_usecases.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/books_provider.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';

final addBookUseCaseProvider = Provider((ref) {
  return AddBookUseCase(ref.read(booksRepositoryProvider));
});

class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({super.key});

  @override
  ConsumerState<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Optional URL input

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authProvider).user;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add a book')),
        );
        return;
      }

      final newBook = Book(
        id: '', // Generated in Repo
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'General'
            : _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        userId: user.id,
        // Defaults
        rating: 0,
        isFavorite: false,
        downloadCount: 0,
        languages: const ['en'],
        subjects: const [],
      );

      final result = await ref.read(addBookUseCaseProvider)(newBook);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to add book')));
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully!')),
          );
          // Refresh user books
          ref.invalidate(userBooksProvider);
          context.pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: _titleController,
                hintText: 'Title',
                validator: (v) => v!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _authorController,
                hintText: 'Author',
                validator: (v) => v!.isEmpty ? 'Author is required' : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _descriptionController,
                hintText: 'Description',
                // multiline
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _categoryController,
                hintText: 'Category (Optional)',
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _imageUrlController,
                hintText: 'Image URL (Optional)',
              ),
              const SizedBox(height: 32),
              FilledButton(onPressed: _submit, child: const Text('Save Book')),
            ],
          ),
        ),
      ),
    );
  }
}
