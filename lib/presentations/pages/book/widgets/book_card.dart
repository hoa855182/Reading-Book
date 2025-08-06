import 'package:flutter/material.dart';
import '../../../controllers/book/book_controller.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedChapters = book.chapters.where((chapter) => chapter.isUnlocked).length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book cover
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: const Icon(
                  Icons.book,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),

              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.menu_book,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$unlockedChapters/${book.totalChapters} chapters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    LinearProgressIndicator(
                      value: book.totalChapters > 0 ? unlockedChapters / book.totalChapters : 0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                      minHeight: 4,
                    ),
                  ],
                ),
              ),

              // Favorite button
              IconButton(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  book.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: book.isFavorite ? Colors.red : Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
