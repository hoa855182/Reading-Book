import 'package:flutter/material.dart';

class AddCoinAnimation extends StatefulWidget {
  final Animation<double> animation;
  final Offset startPosition;
  final Offset endPosition;

  const AddCoinAnimation({
    super.key,
    required this.animation,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  State<AddCoinAnimation> createState() => _AddCoinAnimationState();
}

class _AddCoinAnimationState extends State<AddCoinAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final progress = widget.animation.value;

        // Calculate current position
        final currentX = widget.startPosition.dx + (widget.endPosition.dx - widget.startPosition.dx) * progress;
        final currentY = widget.startPosition.dy + (widget.endPosition.dy - widget.startPosition.dy) * progress;

        // Add some curve to the path
        final curve = Curves.easeInOut.transform(progress);
        final curvedY = currentY - (50 * curve * (1 - curve)); // Parabolic curve

        // Scale and rotation effects
        // Scale starts large and gets smaller as it approaches the end
        final scale = 1.0 - (0.4 * progress); // Scale from 1.0 to 0.6
        final rotation = progress * 2 * 3.14159; // Full rotation

        // Debug: Print current position
        if (progress % 0.1 < 0.01) {
          // Print every 10% progress
          print('AddCoinAnimation: Progress: ${(progress * 100).toStringAsFixed(0)}%, Position: ($currentX, $curvedY)');
        }

        return Positioned(
          left: currentX - 20,
          top: curvedY - 20,
          child: Opacity(
            opacity: (1.0 - (0.3 * progress)).clamp(0.0, 1.0), // Clamp opacity to valid range
            child: Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: rotation,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3), // Thicker white border
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber
                            .withOpacity((0.8 * (1.0 - 0.3 * progress)).clamp(0.0, 1.0)), // Clamp shadow opacity too
                        blurRadius: 12,
                        spreadRadius: 4,
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

class AddCoinsAnimationOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final int coinCount;
  final Offset? startPosition;
  final Offset? endPosition;
  final int? coinAmount;

  const AddCoinsAnimationOverlay({
    super.key,
    required this.onComplete,
    this.coinCount = 5,
    this.startPosition,
    this.endPosition,
    this.coinAmount,
  });

  @override
  State<AddCoinsAnimationOverlay> createState() => _AddCoinsAnimationOverlayState();
}

class _AddCoinsAnimationOverlayState extends State<AddCoinsAnimationOverlay> with TickerProviderStateMixin {
  late List<AnimationController> coinControllers;
  late List<Animation<double>> coinAnimations;

  @override
  void initState() {
    super.initState();

    coinControllers = List.generate(
      widget.coinCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)), // Staggered animation
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

    // Start animations with delay
    for (int i = 0; i < coinControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          print('AddCoinsAnimationOverlay: Starting coin animation $i');
          coinControllers[i].forward();
        }
      });
    }

    // Listen for completion
    coinControllers.last.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('AddCoinsAnimationOverlay: Animation completed');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in coinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Use provided positions or defaults
    final startX = widget.startPosition?.dx ?? screenSize.width * 0.8;
    final startY = widget.startPosition?.dy ?? screenSize.height * 0.8;
    final endX = widget.endPosition?.dx ?? screenSize.width * 0.8;
    final endY = widget.endPosition?.dy ?? 100.0;

    return Stack(
      children: [
        ...List.generate(widget.coinCount, (index) {
          return AddCoinAnimation(
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
                final opacity = ((progress - 0.7) / 0.3).clamp(0.0, 1.0); // Clamp opacity to valid range
                return Positioned(
                  left: endX - 30,
                  top: endY - 40,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: (0.8 + (0.2 * opacity)).clamp(0.0, 2.0), // Clamp scale to reasonable range
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
