import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const TechLinesOverlay(),
          ],
        ),
      ),
    );
  }
}

class TechLinesOverlay extends StatefulWidget {
  const TechLinesOverlay({super.key});

  @override
  State<TechLinesOverlay> createState() => _TechLinesOverlayState();
}

class _TechLinesOverlayState extends State<TechLinesOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
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
        return CustomPaint(
          painter: TechLinesPainter(_controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class TechLinesPainter extends CustomPainter {
  final double progress;
  TechLinesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final int lineCount = 8;
    final double spacing = size.height / (lineCount + 1);
    final double moveDistance = size.width;

    for (int i = 0; i < lineCount; i++) {
      double y = spacing * (i + 1);
      double xOffset = (progress * moveDistance + i * 60) % size.width;
      // Draw a horizontal tech line with some vertical segments
      Path path = Path();
      path.moveTo(-xOffset, y);
      for (double x = -xOffset; x < size.width; x += 80) {
        path.lineTo(x + 40, y);
        path.lineTo(x + 40, y - 10 + (i % 2 == 0 ? 10 : -10));
        path.lineTo(x + 80, y - 10 + (i % 2 == 0 ? 10 : -10));
        path.lineTo(x + 80, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TechLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
