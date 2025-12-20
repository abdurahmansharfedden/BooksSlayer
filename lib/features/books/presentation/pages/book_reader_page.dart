import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/book.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;

  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  @override
  void initState() {
    super.initState();
    _launchBook();
  }

  Future<void> _launchBook() async {
    if (widget.book.readUrl != null) {
      final Uri url = Uri.parse(widget.book.readUrl!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch book reader')),
          );
        }
      } else {
        // If launched successfully, pop back because we open in external browser
        // Or if using InAppWebView, stay here.
        // Since we are using external for now (as per adding only url_launcher)
        // We might want to just show a "Open" button instead of auto-launching to be less intrusive
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "Opening ${widget.book.title}...",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (widget.book.readUrl != null)
              ElevatedButton.icon(
                onPressed: _launchBook,
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Open in Browser"),
              )
            else
              const Text("No readable version available."),
          ],
        ),
      ),
    );
  }
}
