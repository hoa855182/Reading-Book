import 'package:flutter/material.dart';
import 'package:reading_book_app/presentations/pages/book/widgets/book_card_shimmer.dart';

class BookCardShimmerList extends StatelessWidget {
  final int itemCount;

  const BookCardShimmerList({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // This will be handled by the parent widget
        await Future.delayed(const Duration(milliseconds: 100));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: BookCardShimmer(),
          );
        },
      ),
    );
  }
}