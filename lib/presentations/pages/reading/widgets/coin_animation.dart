import 'package:flutter/material.dart';

class CoinAnimation extends StatefulWidget {
  final Animation<double> animation;
  final Offset startPosition;
  final Offset endPosition;

  const CoinAnimation({
    super.key,
    required this.animation,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  State<CoinAnimation> createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<CoinAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final progress = widget.animation.value;

        // Calculate current position
        final currentX = widget.startPosition.dx + (widget.endPosition.dx - widget.startPosition.dx) * progress;
        final currentY = widget.startPosition.dy + (widget.endPosition.dy - widget.startPosition.dy) * progress;

        // Add some arc to the animation
        final arcHeight = 50.0;
        final arcProgress = progress * 2 - 1; // -1 to 1
        final arcY = currentY - arcHeight * (1 - arcProgress * arcProgress);

        return Positioned(
          left: currentX - 12, // Center the coin
          top: arcY - 12,
          child: Transform.scale(
            scale: 1.0 - progress * 0.3, // Slightly shrink as it moves
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CoinAnimationOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final int coinCount;

  const CoinAnimationOverlay({
    super.key,
    required this.onComplete,
    this.coinCount = 5,
  });

  @override
  State<CoinAnimationOverlay> createState() => _CoinAnimationOverlayState();
}

class _CoinAnimationOverlayState extends State<CoinAnimationOverlay> with TickerProviderStateMixin {
  late List<AnimationController> coinControllers;
  late List<Animation<double>> coinAnimations;

  @override
  void initState() {
    super.initState();

    coinControllers = List.generate(
      widget.coinCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );

    coinAnimations = coinControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Start animations with slight delays
    for (int i = 0; i < coinControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          coinControllers[i].forward();
        }
      });
    }

    // Listen for completion
    coinControllers.last.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (final controller in coinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.coinCount, (index) {
        final screenSize = MediaQuery.of(context).size;
        final startX = screenSize.width * 0.8; // Start from right side
        final startY = 100.0; // Start from top
        final endX = screenSize.width * 0.5; // End in center
        final endY = screenSize.height * 0.5; // End in center

        return CoinAnimation(
          animation: coinAnimations[index],
          startPosition: Offset(startX, startY),
          endPosition: Offset(endX, endY),
        );
      }),
    );
  }
}
