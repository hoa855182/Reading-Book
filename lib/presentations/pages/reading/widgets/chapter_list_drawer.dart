import 'package:flutter/material.dart';
import '../../../controllers/book/book_controller.dart';

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
            color: Colors.amber[600],
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${book.author}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.book,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${book.chapters.length} chapters',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Chapter list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: book.chapters.length,
              itemBuilder: (context, index) {
                final chapter = book.chapters[index];
                final isSelected = index == currentChapterIndex;
                final isUnlocked = chapter.isUnlocked;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[600] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: isUnlocked
                            ? Icon(
                                Icons.menu_book,
                                color: isSelected ? Colors.white : Colors.grey[600],
                                size: 20,
                              )
                            : Icon(
                                Icons.lock,
                                color: isSelected ? Colors.white : Colors.grey[600],
                                size: 20,
                              ),
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
                        color: isUnlocked ? Colors.grey[600] : Colors.amber[600],
                        fontSize: 12,
                      ),
                    ),
                    trailing: isUnlocked
                        ? (isSelected ? Icon(Icons.check_circle, color: Colors.blue[600]) : null)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.amber[600],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${chapter.unlockCost}',
                                style: TextStyle(
                                  color: Colors.amber[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                    onTap: () {
                      if (isUnlocked) {
                        onChapterSelected(index);
                      } else {
                        onUnlockChapter(chapter.id);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Footer with progress
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${book.chapters.where((ch) => ch.isUnlocked).length}/${book.chapters.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: book.chapters.where((ch) => ch.isUnlocked).length / book.chapters.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
