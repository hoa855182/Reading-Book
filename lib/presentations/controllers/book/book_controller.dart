import 'package:get/get.dart';

class BookController extends GetxController {
  // Observable variables
  final RxList<Book> books = <Book>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt userCoins = 100.obs; // Starting coins

  // Coin animation state
  final RxBool showAddCoinsAnimation = false.obs;
  final RxInt pendingCoins = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data with chapters
      final mockBooks = [
        Book(
          id: '1',
          title: 'The Lost City of Eldoria',
          author: 'Sarah Mitchell',
          description:
              'A thrilling adventure about a young explorer who discovers an ancient city with mysterious powers.',
          coverImage: 'assets/images/book1.jpg',
          rating: 4.5,
          totalChapters: 15,
          chapters: _generateChapters(15),
        ),
        Book(
          id: '2',
          title: 'The Quantum Paradox',
          author: 'Dr. Michael Chen',
          description: 'A sci-fi thriller about time travel and the consequences of altering the past.',
          coverImage: 'assets/images/book2.jpg',
          rating: 4.8,
          totalChapters: 12,
          chapters: _generateChapters(12),
        ),
        Book(
          id: '3',
          title: 'The Last Guardian',
          author: 'Emma Rodriguez',
          description: 'A fantasy epic about the last guardian protecting the world from ancient evil.',
          coverImage: 'assets/images/book3.jpg',
          rating: 4.3,
          totalChapters: 20,
          chapters: _generateChapters(20),
        ),
      ];

      books.assignAll(mockBooks);
    } catch (e) {
      errorMessage.value = 'Failed to load books: $e';
    } finally {
      isLoading.value = false;
    }
  }

  List<Chapter> _generateChapters(int count) {
    List<Chapter> chapters = [];
    for (int i = 1; i <= count; i++) {
      chapters.add(Chapter(
        id: i.toString(),
        title: 'Chapter $i',
        content: _generateChapterContent(i),
        isUnlocked: i == 1, // Only first chapter is unlocked by default
        unlockCost: i == 1 ? 0 : 10, // First chapter is free, others cost 10 coins
      ));
    }
    return chapters;
  }

  String _generateChapterContent(int chapterNumber) {
    // Generate fictional story content for each chapter
    final storyTemplates = [
      'The air crackled with anticipation as the ancient doors slowly creaked open. Dust particles danced in the dim light filtering through the narrow windows. Sarah\'s heart pounded in her chest as she stepped forward, her boots echoing against the stone floor.',
      'Deep within the quantum realm, time itself seemed to bend and twist. Dr. Chen watched in amazement as the temporal rift pulsed with an otherworldly energy. The consequences of his experiment were far greater than he had ever imagined.',
      'The guardian\'s sword gleamed in the moonlight as she prepared for the final battle. Centuries of training had led to this moment. The fate of the world rested on her shoulders, and she would not fail.',
      'Whispers echoed through the ancient corridors, carrying secrets that had been buried for millennia. Each step forward revealed new mysteries, new dangers, and new possibilities that could change everything.',
      'The storm raged outside, but inside the old library, a different kind of storm was brewing. Pages of ancient texts fluttered as an unseen force stirred the very fabric of reality.',
      'In the depths of the forgotten temple, symbols carved into the walls began to glow with an ethereal light. The prophecy was unfolding, and there was no turning back now.',
      'The city of Eldoria stood silent and majestic, its spires reaching toward the heavens. But beneath its beautiful facade lay secrets that could destroy everything Sarah had ever known.',
      'Time itself seemed to stand still as the quantum particles collided. The paradox was real, and Dr. Chen realized that he had opened a door that could never be closed.',
      'The guardian\'s ancient magic pulsed through her veins as she faced the darkness. Her ancestors had fought this battle before, and now it was her turn to protect the light.',
      'The ancient scrolls revealed truths that had been hidden for generations. Each word, each symbol, told a story of power, betrayal, and redemption.',
      'The crystal chamber hummed with energy as the ritual began. The fate of worlds hung in the balance, and every decision made in this moment would echo through eternity.',
      'Shadows danced on the walls as the truth began to emerge. What had seemed like a simple quest had become a journey into the heart of darkness itself.',
      'The prophecy spoke of a chosen one who would bring balance to the forces of light and shadow. But prophecies could be misinterpreted, and the consequences of failure were too terrible to contemplate.',
      'In the quantum realm, cause and effect became meaningless. Dr. Chen watched as reality itself began to unravel, and he knew that he alone could fix what he had broken.',
      'The guardian\'s final stand would be remembered for generations. Her sacrifice would ensure that the light would never be extinguished, no matter how dark the world became.',
    ];

    // Use different templates for different chapters
    final templateIndex = (chapterNumber - 1) % storyTemplates.length;
    final baseContent = storyTemplates[templateIndex];

    // Add more content to make chapters longer
    return '''
$baseContent

The journey continued as the protagonist faced new challenges and discovered hidden truths. Each chapter brought them closer to their ultimate goal, but also revealed new dangers that threatened to derail their mission.

The supporting characters played crucial roles in this unfolding drama, their own motivations and secrets adding layers of complexity to the narrative. Friendships were tested, alliances were formed and broken, and the true nature of the quest became clearer with each passing moment.

As the story progressed, the stakes grew higher and the consequences of failure became more dire. The protagonist had to make difficult choices that would affect not only their own fate, but the fate of everyone they cared about.

The world around them was changing, and they had to adapt quickly to survive. Ancient powers were awakening, and the balance of forces that had maintained peace for generations was beginning to shift.

In the end, it would all come down to a single moment of decision, a choice that would determine the course of history and the future of all who lived in this world.
''';
  }

  void searchBooks(String query) {
    searchQuery.value = query;
  }

  void toggleFavorite(String bookId) {
    final bookIndex = books.indexWhere((book) => book.id == bookId);
    if (bookIndex != -1) {
      final book = books[bookIndex];
      final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
      books[bookIndex] = updatedBook;
    }
  }

  bool unlockChapter(String bookId, String chapterId) {
    final bookIndex = books.indexWhere((book) => book.id == bookId);
    if (bookIndex == -1) return false;

    final book = books[bookIndex];
    final chapterIndex = book.chapters.indexWhere((chapter) => chapter.id == chapterId);
    if (chapterIndex == -1) return false;

    final chapter = book.chapters[chapterIndex];
    if (chapter.isUnlocked) return true; // Already unlocked

    if (userCoins.value >= chapter.unlockCost) {
      userCoins.value -= chapter.unlockCost;

      final updatedChapter = chapter.copyWith(isUnlocked: true);
      final updatedChapters = List<Chapter>.from(book.chapters);
      updatedChapters[chapterIndex] = updatedChapter;

      final updatedBook = book.copyWith(chapters: updatedChapters);
      books[bookIndex] = updatedBook;

      return true;
    }

    return false; // Not enough coins
  }

  void addCoins(int amount) {
    userCoins.value += amount;
  }

  void startAddCoinsAnimation(int amount) {
    pendingCoins.value = amount;
    showAddCoinsAnimation.value = true;
  }

  void onAddCoinsAnimationComplete() {
    userCoins.value += pendingCoins.value;
    showAddCoinsAnimation.value = false;
    pendingCoins.value = 0;
  }

  List<Book> get filteredBooks {
    if (searchQuery.value.isEmpty) {
      return books;
    }
    return books
        .where((book) =>
            book.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            book.author.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  Book? getBookById(String bookId) {
    try {
      return books.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImage;
  final double rating;
  final int totalChapters;
  final List<Chapter> chapters;
  final bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImage,
    required this.rating,
    required this.totalChapters,
    required this.chapters,
    this.isFavorite = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImage,
    double? rating,
    int? totalChapters,
    List<Chapter>? chapters,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      rating: rating ?? this.rating,
      totalChapters: totalChapters ?? this.totalChapters,
      chapters: chapters ?? this.chapters,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Chapter {
  final String id;
  final String title;
  final String content;
  final bool isUnlocked;
  final int unlockCost;

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.isUnlocked,
    required this.unlockCost,
  });

  Chapter copyWith({
    String? id,
    String? title,
    String? content,
    bool? isUnlocked,
    int? unlockCost,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }
}
