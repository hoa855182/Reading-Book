import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book/book_controller.dart';
import 'widgets/book_card.dart';
import '../../routes/app_routes.dart';

class BookListPage extends GetView<BookController> {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Reading Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Obx(() => Text(
                        '${controller.userCoins.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading books...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadBooks,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final books = controller.filteredBooks;

        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.searchQuery.value.isEmpty
                      ? 'No books available'
                      : 'No books found for "${controller.searchQuery.value}"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadBooks,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BookCard(
                  book: book,
                  onTap: () => _navigateToReading(book),
                  onFavoriteToggle: () => controller.toggleFavorite(book.id),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addCoins(50);
          Get.snackbar(
            'Coins Added!',
            'You received 50 coins!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        backgroundColor: Colors.amber[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToReading(Book book) {
    Get.toNamed(Routes.reading, arguments: book.id);
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Books'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter book title or author...',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.searchBooks,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.searchBooks('');
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
