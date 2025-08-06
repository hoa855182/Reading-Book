import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../book/book_controller.dart';

class ReadingController extends GetxController {
  final BookController bookController;
  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key

  // Reading state
  final RxInt currentChapterIndex = 0.obs;
  final RxInt currentPage = 0.obs;
  final RxBool isScrollMode = false.obs;
  final RxBool showChapterList = false.obs;

  // Coin animation state
  final RxBool showCoinAnimation = false.obs;
  final RxString unlockingChapterId = ''.obs;

  // Current book and chapter - make them observable
  final Rx<Book?> currentBook = Rx<Book?>(null);
  final Rx<Chapter?> currentChapter = Rx<Chapter?>(null);

  // Page controller for swipe mode
  late PageController pageController;

  late String bookId;

  // Current book and chapter
  Book? _book;
  Chapter? _chapter;

  // Scroll controller for scroll mode
  late ScrollController scrollController;

  ReadingController({required this.bookController}) {
    final arguments = Get.arguments;
    if (arguments is String) {
      bookId = arguments;
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeBook(bookId);
    pageController = PageController();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void initializeBook(String bookId) {
    this.bookId = bookId;
    _book = bookController.getBookById(bookId);
    currentBook.value = _book;
    if (_book != null && _book!.chapters.isNotEmpty) {
      _chapter = _book!.chapters[0];
      currentChapter.value = _chapter;
      currentChapterIndex.value = 0;
    }
  }

  void setCurrentChapter(int index) {
    if (_book != null && index >= 0 && index < _book!.chapters.length) {
      currentChapterIndex.value = index;
      _chapter = _book!.chapters[index];
      currentChapter.value = _chapter;

      // Update page controller if in swipe mode
      if (!isScrollMode.value) {
        // Calculate the page index for this chapter
        int pageIndex = 0;
        for (int i = 0; i < index; i++) {
          final chapter = _book!.chapters[i];
          if (chapter.isUnlocked) {
            pageIndex += getPageContent(chapter.content).length;
          } else {
            pageIndex += 1;
          }
        }
        currentPage.value = pageIndex;
        pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void nextChapter() {
    if (_book != null && currentChapterIndex.value < _book!.chapters.length - 1) {
      setCurrentChapter(currentChapterIndex.value + 1);
    }
  }

  void previousChapter() {
    if (currentChapterIndex.value > 0) {
      setCurrentChapter(currentChapterIndex.value - 1);
    }
  }

  void toggleReadingMode() {
    isScrollMode.value = !isScrollMode.value;
  }

  void toggleChapterList() {
    key.currentState!.openDrawer();
  }

  bool canUnlockChapter(String chapterId) {
    if (_book == null) return false;

    final chapter = _book!.chapters.firstWhere(
      (ch) => ch.id == chapterId,
      orElse: () => Chapter(id: '', title: '', content: '', isUnlocked: false, unlockCost: 0),
    );

    return !chapter.isUnlocked && bookController.userCoins.value >= chapter.unlockCost;
  }

  bool unlockChapter(String chapterId) {
    if (_book == null) return false;

    final success = bookController.unlockChapter(_book!.id, chapterId);
    if (success) {
      // Refresh current book data
      _book = bookController.getBookById(_book!.id);
      currentBook.value = _book;
      if (_book != null) {
        _chapter = _book!.chapters[currentChapterIndex.value];
        currentChapter.value = _chapter;
      }
    }
    return success;
  }

  void unlockChapterWithAnimation(String chapterId) {
    final success = unlockChapter(chapterId);
    if (success) {
      Get.snackbar(
        'Chapter Unlocked!',
        'You can now read this chapter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Not Enough Coins!',
        'You need more coins to unlock this chapter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void unlockChapterSilently(String chapterId) {
    unlockChapter(chapterId);
  }

  // Coin animation methods
  void startCoinAnimation(String chapterId) {
    if (canUnlockChapter(chapterId)) {
      showCoinAnimation.value = true;
      unlockingChapterId.value = chapterId;
    } else {
      Get.snackbar(
        'Not Enough Coins!',
        'You need more coins to unlock this chapter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onCoinAnimationComplete() {
    if (unlockingChapterId.value.isNotEmpty) {
      unlockChapterSilently(unlockingChapterId.value);
      showCoinAnimation.value = false;
      unlockingChapterId.value = '';
    }
  }

  List<String> getPageContent(String content) {
    // Split content into pages for swipe mode
    const wordsPerPage = 150;
    final words = content.split(' ');
    final pages = <String>[];

    for (int i = 0; i < words.length; i += wordsPerPage) {
      final end = (i + wordsPerPage < words.length) ? i + wordsPerPage : words.length;
      final pageWords = words.sublist(i, end);
      pages.add(pageWords.join(' '));
    }

    return pages;
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    // Calculate which chapter this page belongs to
    if (_book != null) {
      int pageCount = 0;
      for (int i = 0; i < _book!.chapters.length; i++) {
        final chapter = _book!.chapters[i];
        if (chapter.isUnlocked) {
          final chapterPages = getPageContent(chapter.content).length;
          if (page >= pageCount && page < pageCount + chapterPages) {
            currentChapterIndex.value = i;
            _chapter = chapter;
            currentChapter.value = _chapter;
            break;
          }
          pageCount += chapterPages;
        } else {
          if (page == pageCount) {
            currentChapterIndex.value = i;
            _chapter = chapter;
            currentChapter.value = _chapter;
            break;
          }
          pageCount += 1;
        }
      }
    }
  }

  double getReadingProgress() {
    if (_book == null || _book!.chapters.isEmpty) return 0.0;
    return (currentChapterIndex.value + 1) / _book!.chapters.length;
  }

  int getUnlockedChaptersCount() {
    if (_book == null) return 0;
    return _book!.chapters.where((chapter) => chapter.isUnlocked).length;
  }

  // Navigation methods
  void goBack() {
    Get.back();
  }

  // Get total pages for BookPageView
  int getTotalPages() {
    if (_book == null) return 0;
    int totalPages = 0;
    for (final chapter in _book!.chapters) {
      if (chapter.isUnlocked) {
        totalPages += getPageContent(chapter.content).length;
      } else {
        totalPages += 1; // Locked chapter takes one page
      }
    }
    return totalPages;
  }

  // Get current page index for BookPageView
  int getCurrentPageIndex() {
    if (_book == null) return 0;
    int pageIndex = 0;
    for (int i = 0; i < currentChapterIndex.value; i++) {
      final chapter = _book!.chapters[i];
      if (chapter.isUnlocked) {
        pageIndex += getPageContent(chapter.content).length;
      } else {
        pageIndex += 1;
      }
    }
    return pageIndex;
  }
}
