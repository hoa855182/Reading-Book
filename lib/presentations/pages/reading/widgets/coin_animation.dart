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
          child: Opacity(
            opacity: (1.0 - (0.3 * progress)).clamp(0.0, 1.0), // Fade out slightly as it approaches
            child: Transform.scale(
              scale: (1.0 - progress * 0.4).clamp(0.0, 2.0), // Scale from 1.0 to 0.6
              child: Transform.rotate(
                angle: progress * 4 * 3.14159, // Rotate 2 full rotations
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2), // Add white border for visibility
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity((0.3 * (1 - progress)).clamp(0.0, 1.0)),
                        blurRadius: 8 * (1 - progress),
                        spreadRadius: 2 * (1 - progress),
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
  final Offset? startPosition;
  final Offset? endPosition;
  final int? coinAmount; // For add coins animation

  const CoinAnimationOverlay({
    super.key,
    required this.onComplete,
    this.coinCount = 5,
    this.startPosition,
    this.endPosition,
    this.coinAmount,
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
    final screenSize = MediaQuery.of(context).size;

    // Default positions if not provided
    final startX = widget.startPosition?.dx ?? screenSize.width * 0.8;
    final startY = widget.startPosition?.dy ?? 100.0;
    final endX = widget.endPosition?.dx ?? screenSize.width * 0.5;
    final endY = widget.endPosition?.dy ?? screenSize.height * 0.5;

    return Stack(
      children: [
        ...List.generate(widget.coinCount, (index) {
          return CoinAnimation(
            animation: coinAnimations[index],
            startPosition: Offset(startX, startY),
            endPosition: Offset(endX, endY),
          );
        }),
        // Show coin amount text when animation is almost complete
        if (widget.coinAmount != null)
          AnimatedBuilder(
            animation: coinControllers.last,
            builder: (context, child) {
              final progress = coinControllers.last.value;
              if (progress > 0.7) {
                final opacity = ((progress - 0.7) / 0.3).clamp(0.0, 1.0); // Fade in from 0.7 to 1.0
                return Positioned(
                  left: endX - 30,
                  top: endY - 40,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: (0.8 + (0.2 * opacity)).clamp(0.0, 2.0), // Scale up as it appears
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          '+${widget.coinAmount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
