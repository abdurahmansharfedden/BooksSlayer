import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'category_books_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Fiction', 'icon': Icons.auto_stories, 'color': Color(0xFFFFBCBC)},
    {
      'name': 'Business',
      'icon': Icons.business_center,
      'color': Color(0xFFB5EAEA),
    },
    {'name': 'Programming', 'icon': Icons.code, 'color': Color(0xFFFBF7D5)},
    {'name': 'Self-Help', 'icon': Icons.psychology, 'color': Color(0xFFC8E6C9)},
    {'name': 'Science', 'icon': Icons.science, 'color': Color(0xFFE1BEE7)},
    {'name': 'History', 'icon': Icons.history_edu, 'color': Color(0xFFFFD180)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(context, category, index);
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> category,
    int index,
  ) {
    return Card(
      color: category['color'],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryBooksPage(
                categoryName: category['name'],
                categoryId: category['name'].toString().toLowerCase(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: Icon(category['icon'], size: 32, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              category['name'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.2, end: 0);
  }
}
