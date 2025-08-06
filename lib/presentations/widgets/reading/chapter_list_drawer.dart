import 'package:flutter/material.dart';
import '../../controllers/book/book_controller.dart';

class ChapterListDrawer extends StatelessWidget {
  final Book book;
  final int currentChapterIndex;
  final Function(int) onChapterSelected;
  final Function(String) onUnlockChapter;

  const ChapterListDrawer({
    super.key,
    required this.book,
    required this.currentChapterIndex,
    required this.onChapterSelected,
    required this.onUnlockChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[600],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress indicator
                  LinearProgressIndicator(
                    value: book.chapters.where((chapter) => chapter.isUnlocked).length / book.chapters.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${book.chapters.where((chapter) => chapter.isUnlocked).length} of ${book.chapters.length} chapters unlocked',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chapter list
          Expanded(
            child: ListView.builder(
              itemCount: book.chapters.length,
              itemBuilder: (context, index) {
                final chapter = book.chapters[index];
                final isSelected = index == currentChapterIndex;
                final isUnlocked = chapter.isUnlocked;

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[600] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isUnlocked ? Icons.menu_book : Icons.lock,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  title: Text(
                    chapter.title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isUnlocked ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  subtitle: Text(
                    isUnlocked ? 'Tap to read' : '${chapter.unlockCost} coins to unlock',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUnlocked ? Colors.grey[600] : Colors.amber[600],
                    ),
                  ),
                  trailing: isUnlocked
                      ? null
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chapter.unlockCost}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                  onTap: () {
                    if (isUnlocked) {
                      onChapterSelected(index);
                    } else {
                      onUnlockChapter(chapter.id);
                    }
                  },
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available coins: 100',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
