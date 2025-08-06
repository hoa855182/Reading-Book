import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reading_book_app/presentations/pages/book/widgets/book_card_shimmer_list.dart';
import '../../controllers/book/book_controller.dart';
import 'widgets/book_card.dart';
import '../../routes/app_routes.dart';
import 'widgets/add_coins_animation.dart';

class BookListPage extends GetView<BookController> {
  BookListPage({super.key});

  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _coinBalanceKey = GlobalKey();
  OverlayEntry? _overlayEntry;

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
              key: _coinBalanceKey,
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
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // TODO: Implement favorites
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const BookCardShimmerList(itemCount: 6);
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
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
        key: _fabKey,
        onPressed: () {
          controller.startAddCoinsAnimation(50);
          _showAnimationOverlay();
        },
        backgroundColor: Colors.amber[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAnimationOverlay() {
    print('BookListPage: _showAnimationOverlay called');

    // Remove existing overlay if any
    _overlayEntry?.remove();

    // Try different ways to get overlay
    OverlayState? overlay;
    try {
      overlay = Overlay.of(Get.context!);
      
    } catch (e) {
     
      try {
        overlay = Navigator.of(Get.context!).overlay;
      
      } catch (e2) {
       
        return;
      }
    }

    final startPos = _getFloatingActionButtonPosition(Get.context!);
    final endPos = _getCoinBalancePosition(Get.context!);

 

    _overlayEntry = OverlayEntry(
      builder: (context) => AddCoinsAnimationOverlay(
        onComplete: () {
          controller.onAddCoinsAnimationComplete();
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        coinCount: 5,
        coinAmount: controller.pendingCoins.value,
        startPosition: startPos,
        endPosition: endPos,
      ),
    );

    overlay?.insert(_overlayEntry!);
  }

  Offset? _getFloatingActionButtonPosition(BuildContext context) {
    try {
      final RenderBox? renderBox = _fabKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        return Offset(position.dx + renderBox.size.width / 2, position.dy + renderBox.size.height / 2);
      }
    } catch (e) {
    }

    // Fallback to calculated position
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final fabX = screenWidth - 80;
    final fabY = screenHeight - 120;
    return Offset(fabX, fabY);
  }

  Offset? _getCoinBalancePosition(BuildContext context) {
    try {
      final RenderBox? renderBox = _coinBalanceKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        return Offset(position.dx + renderBox.size.width / 2, position.dy + renderBox.size.height / 2);
      }
    } catch (e) {
    }

    // Fallback to calculated position
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final coinsDisplayY = statusBarHeight + appBarHeight / 2;
    final coinsDisplayX = MediaQuery.of(context).size.width - 80;
    return Offset(coinsDisplayX, coinsDisplayY);
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
