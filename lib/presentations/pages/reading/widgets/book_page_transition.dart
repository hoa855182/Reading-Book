import 'package:flutter/material.dart';

class BookPageView extends StatefulWidget {
  final List<Widget> pages;
  final PageController controller;
  final Function(int) onPageChanged;
  final int currentPage;

  const BookPageView({
    super.key,
    required this.pages,
    required this.controller,
    required this.onPageChanged,
    required this.currentPage,
  });

  @override
  State<BookPageView> createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            double value = 1.0;
            double rotation = 0.0;

            try {
              if (widget.controller.position.haveDimensions && widget.controller.page != null) {
                final page = widget.controller.page!;
                value = page - index;
                value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                rotation = value * 0.1 * (page > index ? -1 : 1);
              }
            } catch (e) {
              // Fallback to default values if there's any error
              value = 1.0;
              rotation = 0.0;
            }

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(rotation)
                ..scale(value),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15 * value),
                      blurRadius: 15 * value,
                      offset: Offset(0, 4 * value),
                      spreadRadius: 1 * value,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1 * value),
                      blurRadius: 5 * value,
                      offset: Offset(0, 2 * value),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.pages[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Simple BookPageView without complex animations for better stability
class SimpleBookPageView extends StatelessWidget {
  final List<Widget> pages;
  final PageController controller;
  final Function(int) onPageChanged;

  const SimpleBookPageView({
    super.key,
    required this.pages,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: pages[index],
          ),
        );
      },
    );
  }
}

// Legacy BookPageTransition for backward compatibility
class BookPageTransition extends StatefulWidget {
  final Widget child;
  final bool isForward;
  final VoidCallback? onAnimationComplete;

  const BookPageTransition({
    super.key,
    required this.child,
    required this.isForward,
    this.onAnimationComplete,
  });

  @override
  State<BookPageTransition> createState() => _BookPageTransitionState();
}

class _BookPageTransitionState extends State<BookPageTransition> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.isForward ? -0.3 : 0.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(_rotationAnimation.value)
            ..scale(_scaleAnimation.value),
          alignment: widget.isForward ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3 * _shadowAnimation.value),
                  blurRadius: 20 * _shadowAnimation.value,
                  offset: Offset(
                    widget.isForward ? -10 * _shadowAnimation.value : 10 * _shadowAnimation.value,
                    5 * _shadowAnimation.value,
                  ),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2 * _shadowAnimation.value),
                  blurRadius: 5 * _shadowAnimation.value,
                  offset: Offset(
                    widget.isForward ? -2 * _shadowAnimation.value : 2 * _shadowAnimation.value,
                    1 * _shadowAnimation.value,
                  ),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
