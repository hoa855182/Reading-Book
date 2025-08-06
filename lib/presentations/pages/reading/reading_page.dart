import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reading/reading_controller.dart';
import '../../controllers/book/book_controller.dart';
import '../../widgets/reading/chapter_list_drawer.dart';
import 'widgets/book_page_transition.dart';
import 'widgets/coin_animation.dart';

class ReadingPage extends GetView<ReadingController> {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: controller.key,
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Obx(() => Text(
                  controller.currentBook.value?.title ?? 'Reading',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: controller.goBack,
            ),
            actions: [
              // Coins display
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            '${controller.bookController.userCoins.value}',
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
                icon: const Icon(Icons.list, color: Colors.white),
                onPressed: controller.toggleChapterList,
              ),
              IconButton(
                icon: Obx(() => Icon(
                      controller.isScrollMode.value ? Icons.swap_horiz : Icons.swap_vert,
                      color: Colors.white,
                    )),
                onPressed: controller.toggleReadingMode,
              ),
            ],
          ),
          body: Obx(() {
            if (controller.currentBook.value == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.isScrollMode.value) {
              return _buildScrollMode();
            } else {
              return _buildSwipeMode();
            }
          }),
          drawer: Obx(() => controller.currentBook.value != null
              ? ChapterListDrawer(
                  book: controller.currentBook.value!,
                  currentChapterIndex: controller.currentChapterIndex.value,
                  onChapterSelected: (index) {
                    controller.setCurrentChapter(index);
                    controller.toggleChapterList();
                  },
                  onUnlockChapter: controller.unlockChapterSilently,
                )
              : const SizedBox.shrink()),
        ),
        Obx(() => controller.showCoinAnimation.value
            ? CoinAnimationOverlay(
                onComplete: controller.onCoinAnimationComplete,
                coinCount: 5,
                startPosition: _getCoinBalancePosition(context),
                endPosition: Offset(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.6),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Offset? _getCoinBalancePosition(BuildContext context) {
    // Calculate position based on AppBar coins display
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final coinsDisplayY = statusBarHeight + appBarHeight / 2;
    final coinsDisplayX = MediaQuery.of(context).size.width - 80; // Approximate position

    return Offset(coinsDisplayX, coinsDisplayY);
  }

  Widget _buildScrollMode() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: double.infinity,
          height: 4,
          color: Colors.grey[300],
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: controller.getReadingProgress(),
            child: Container(
              color: Colors.blue[600],
            ),
          ),
        ),

        // Chapter info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.currentChapter.value?.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.currentChapterIndex.value + 1} of ${controller.currentBook.value?.chapters.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: controller.previousChapter,
                    icon: const Icon(Icons.chevron_left),
                    color: controller.currentChapterIndex.value > 0 ? Colors.blue[600] : Colors.grey,
                  ),
                  IconButton(
                    onPressed: controller.nextChapter,
                    icon: const Icon(Icons.chevron_right),
                    color:
                        controller.currentChapterIndex.value < (controller.currentBook.value?.chapters.length ?? 0) - 1
                            ? Colors.blue[600]
                            : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Text(
                controller.currentChapter.value?.content ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeMode() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: double.infinity,
          height: 4,
          color: Colors.grey[300],
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: controller.getReadingProgress(),
            child: Container(
              color: Colors.blue[600],
            ),
          ),
        ),

        // Chapter info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.currentChapter.value?.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.currentChapterIndex.value + 1} of ${controller.currentBook.value?.chapters.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Page content with book animation
        Expanded(
          child: Obx(() {
            if (controller.currentBook.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final chapters = controller.currentBook.value!.chapters;
            final List<Widget> chapterPages = [];

            for (int i = 0; i < chapters.length; i++) {
              final chapter = chapters[i];

              if (!chapter.isUnlocked) {
                chapterPages.add(_buildLockedChapterCard(chapter));
              } else {
                final pages = controller.getPageContent(chapter.content);
                for (int j = 0; j < pages.length; j++) {
                  chapterPages.add(_buildBookPage(pages[j], j + 1, pages.length));
                }
              }
            }

            return BookPageView(
              pages: chapterPages,
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              currentPage: controller.currentPage.value,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBookPage(String content, int pageNumber, int totalPages) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $pageNumber of $totalPages',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${((pageNumber / totalPages) * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Page content
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: Colors.black87,
                  fontFamily: 'Georgia', // Serif font for book feel
                ),
              ),
            ),
          ),

          // Page footer
          const SizedBox(height: 16),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.currentBook.value?.title ?? '',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Page $pageNumber',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockedChapterCard(Chapter chapter) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            chapter.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This chapter is locked',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => controller.startCoinAnimation(chapter.id),
            icon: const Icon(Icons.lock_open),
            label: Text('Unlock for ${chapter.unlockCost} coins'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
