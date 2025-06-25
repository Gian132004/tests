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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const ParticleNetworkOverlay(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/motologo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/motologo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const ParticleNetworkOverlay(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CautionBar(),
                ),
                const SizedBox(height: 32),
                _EngineButton(
                  icon: Icons.build,
                  label: 'FOUR-STROKE ENGINE',
                  onPressed: () {},
                ),
                const SizedBox(height: 32),
                _EngineButton(
                  icon: Icons.build,
                  label: 'TWO-STROKE ENGINE',
                  onPressed: () {},
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.center,
                  child: CautionBar(),
                ),
                // Footer text at the very bottom, 3 lines only
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    bottom: true, // Ensures text is above system nav bar
                    minimum: EdgeInsets.zero, // No extra space from the edge
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'MOTORUN ENGINE TOOLS PRO VERSION 5.0.9',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ASSISTANCE WITH ENGINE MODIFICATIONS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.05,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'FOR 4-STROKE AND 2-STROKE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _EngineButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 80,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticleNetworkOverlay extends StatefulWidget {
  const ParticleNetworkOverlay({super.key});

  @override
  State<ParticleNetworkOverlay> createState() => _ParticleNetworkOverlayState();
}

class _ParticleNetworkOverlayState extends State<ParticleNetworkOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final int _numParticles = 18;
  final double _maxSpeed = 0.7;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _particles = [];
  }

  void _initParticles(Size size) {
    final random = Random();
    _particles = List.generate(_numParticles, (index) {
      return _Particle(
        position: Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * _maxSpeed * 2,
          (random.nextDouble() - 0.5) * _maxSpeed * 2,
        ),
      );
    });
  }

  void _updateParticles(Size size) {
    for (var p in _particles) {
      p.position += p.velocity;
      // Bounce off edges
      if (p.position.dx < 0 || p.position.dx > size.width) {
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
      }
      if (p.position.dy < 0 || p.position.dy > size.height) {
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
      }
      // Clamp position
      p.position = Offset(
        p.position.dx.clamp(0.0, size.width),
        p.position.dy.clamp(0.0, size.height),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (_particles.isEmpty) {
          _initParticles(size);
        }
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            _updateParticles(size);
            return CustomPaint(
              painter: _ParticleNetworkPainter(_particles),
              size: size,
            );
          },
        );
      },
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  _Particle({required this.position, required this.velocity});
}

class _ParticleNetworkPainter extends CustomPainter {
  final List<_Particle> particles;
  final double maxDistance = 120.0;
  _ParticleNetworkPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 1.0;
    final Paint dotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    // Draw lines between close particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i].position;
        final p2 = particles[j].position;
        final dist = (p1 - p2).distance;
        if (dist < maxDistance) {
          final opacity = (1.0 - dist / maxDistance) * 0.7;
          canvas.drawLine(
            p1,
            p2,
            linePaint..color = linePaint.color.withOpacity(opacity),
          );
        }
      }
    }
    // Draw dots
    for (final p in particles) {
      canvas.drawCircle(p.position, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleNetworkPainter oldDelegate) => true;
}

class CautionBar extends StatelessWidget {
  final double? width;
  final double height;
  const CautionBar({this.width, this.height = 16, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double barWidth = width ?? MediaQuery.of(context).size.width * 0.95;
    return SizedBox(
      width: barWidth,
      height: height,
      child: CustomPaint(
        painter: _CautionBarPainter(),
      ),
    );
  }
}

class _CautionBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double stripeWidth = 16; // Smaller stripes
    final Paint yellowPaint = Paint()..color = const Color(0xFFFFEB3B); // Bright yellow
    final Paint transparentPaint = Paint()..color = Colors.transparent;
    final double height = size.height;
    for (double x = -height; x < size.width + height; x += stripeWidth) {
      final bool isYellow = ((x / stripeWidth).floor() % 2 == 0);
      final paint = isYellow ? yellowPaint : transparentPaint;
      final Path path = Path();
      path.moveTo(x, 0);
      path.lineTo(x + stripeWidth, 0);
      path.lineTo(x + stripeWidth - height, height);
      path.lineTo(x - height, height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
