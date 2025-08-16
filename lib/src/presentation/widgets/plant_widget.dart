import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mindful_marks/src/logic/models/plant.dart';

class PlantWidget extends StatelessWidget {
  final Plant plant;

  const PlantWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    // --- THIS IS THE CORRECTED PART ---
    // We create the CustomPaint widget first, and then call .animate() on it.
    // We pass the target values to the painter directly.
    return CustomPaint(
      painter: PlantPainter(
        // We will animate the 'growth' value, so we pass a placeholder here.
        // The animation will override this value during the build process.
        growth: 0.0,
        vibrancy: plant.vibrancy,
        seed: hashCode,
      ),
      size: const Size(100, 150),
    )
    .animate(
      // The target tells the animation what widget to rebuild. 'self' means
      // it will rebuild the CustomPaint widget itself on every frame.
      target: 1.0, 
    )
    // The .custom effect is perfect for driving a CustomPainter.
    .custom(
      duration: 1500.ms,
      curve: Curves.easeInOutBack,
      begin: 0.0,
      end: plant.growth, // The target growth value
      builder: (context, value, child) {
        // In this builder, we rebuild the widget with the animated value.
        // 'child' here refers to the CustomPaint widget we called .animate() on.
        return CustomPaint(
          // We return a new instance of the painter with the animated 'value'.
          painter: PlantPainter(
            growth: value, // The animated value from the custom effect
            vibrancy: plant.vibrancy,
            seed: hashCode,
          ),
          size: const Size(100, 150),
        );
      },
    );
  }
}

// The PlantPainter class remains exactly the same as before.
class PlantPainter extends CustomPainter {
  final double growth; // 0.0 to 1.0
  final double vibrancy; // 0.0 to 1.0
  final int seed;

  PlantPainter({required this.growth, required this.vibrancy, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    
    final healthyGreen = const Color(0xFF2A4A43);
    final witheredGreen = Colors.brown.shade300;
    final plantColor = Color.lerp(witheredGreen, healthyGreen, vibrancy)!;

    final paint = Paint()
      ..color = plantColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final bottom = Offset(size.width / 2, size.height);
    final top = Offset(size.width / 2, size.height * (1 - growth));
    canvas.drawLine(bottom, top, paint);

    if (growth > 0.3) {
      final leafCount = (growth * 4).floor();
      for (int i = 0; i < leafCount; i++) {
        final leafGrowth = (growth - 0.3) / 0.7;
        final stemPosition = random.nextDouble() * leafGrowth;

        final startPoint = Offset(
          size.width / 2,
          size.height * (1 - (stemPosition * 0.8)),
        );
        
        final side = random.nextBool() ? 1 : -1;
        final controlPoint = Offset(
          size.width / 2 + (side * 40 * leafGrowth * random.nextDouble()),
          startPoint.dy - (20 * leafGrowth),
        );
        final endPoint = Offset(
          size.width / 2 + (side * 10 * leafGrowth),
          startPoint.dy - (40 * leafGrowth * random.nextDouble()),
        );

        final path = Path()
          ..moveTo(startPoint.dx, startPoint.dy)
          ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlantPainter oldDelegate) {
    return oldDelegate.growth != growth || oldDelegate.vibrancy != vibrancy;
  }
}