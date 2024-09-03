library story_status;

import 'dart:math';
import 'package:flutter/material.dart';

// Abstract classes for unseen and seen properties
abstract class SeenProperties {}

abstract class UnseenProperties {}

// Classes for color and gradient properties
class SeenColor extends SeenProperties {
  final Color color;
  SeenColor({required this.color});
}

class SeenGradient extends SeenProperties {
  final Gradient gradient;
  SeenGradient({required this.gradient});
}

class UnseenColor extends UnseenProperties {
  final Color color;
  UnseenColor({required this.color});
}

class UnseenGradient extends UnseenProperties {
  final Gradient gradient;
  UnseenGradient({required this.gradient});
}

class StoryStatus extends StatefulWidget {
  final int numberOfStatus;
  final int indexOfSeenStatus;
  final double spacing;
  final double radius;
  final double padding;
  final Widget? child;
  final double strokeWidth;
  final double angle;
  final SeenProperties seenProperties;
  final UnseenProperties unseenProperties;

  const StoryStatus({
    super.key,
    this.numberOfStatus = 10,
    this.indexOfSeenStatus = 0,
    this.spacing = 10.0,
    this.radius = 50,
    this.padding = 5,
    this.angle = 0,
    this.child,
    this.strokeWidth = 2,
    required this.seenProperties,
    required this.unseenProperties,
  });

  @override
  State<StoryStatus> createState() => _StoryStatusState();
}

class _StoryStatusState extends State<StoryStatus> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: widget.numberOfStatus == 4 ? (pi / 4) : 0,
          child: SizedBox(
            width: widget.radius * 2,
            height: widget.radius * 2,
            child: CustomPaint(
              painter: Arc(
                alreadyWatch: widget.indexOfSeenStatus,
                numberOfArc: widget.numberOfStatus,
                spacing: widget.spacing,
                strokeWidth: widget.strokeWidth,
                seenProperties: widget.seenProperties,
                unseenProperties: widget.unseenProperties,
              ),
            ),
          ),
        ),
        if (widget.child != null)
          SizedBox(
            width: (widget.radius * 2) - widget.padding,
            height: widget.radius * 2 - widget.padding,
            child: widget.child!,
          ),
      ],
    );
  }
}

class Arc extends CustomPainter {
  final int numberOfArc;
  final int alreadyWatch;
  final double spacing;
  final double strokeWidth;
  final SeenProperties seenProperties;
  final UnseenProperties unseenProperties;

  Arc({
    required this.numberOfArc,
    required this.alreadyWatch,
    required this.spacing,
    required this.strokeWidth,
    required this.seenProperties,
    required this.unseenProperties,
  });

  double doubleToAngle(double angle) => angle * pi / 180.0;

  void drawArcWithRadius(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    Paint seenPaint,
    Paint unSeenPaint,
    double start,
    double spacing,
    int number,
    int alreadyWatch,
    Size size,
  ) {
    for (var i = 0; i < number; i++) {
      Paint paint = alreadyWatch - 1 >= i ? seenPaint : unSeenPaint;

      if (alreadyWatch - 1 >= i && seenProperties is SeenGradient) {
        paint.shader = (seenProperties as SeenGradient).gradient.createShader(
              Rect.fromCircle(center: center, radius: radius),
            );
      } else if (alreadyWatch - 1 < i && unseenProperties is UnseenGradient) {
        paint.shader = (unseenProperties as UnseenGradient).gradient.createShader(Rect.fromCircle(center: center, radius: radius));
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        doubleToAngle((start + ((angle + spacing) * i))),
        doubleToAngle(angle),
        false,
        paint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);
    final double radius = size.width / 2.0;
    double angle = numberOfArc == 1 ? 360.0 : (360.0 / numberOfArc - spacing);
    var startingAngle = numberOfArc == 4 ? 5.0 : 270.0;

    Paint seenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (seenProperties is SeenColor) {
      seenPaint.color = (seenProperties as SeenColor).color;
    } else if (seenProperties is SeenGradient) {
      seenPaint.shader = (seenProperties as SeenGradient).gradient.createShader(Rect.fromCircle(center: center, radius: radius));
    }

    Paint unSeenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (unseenProperties is UnseenColor) {
      unSeenPaint.color = (unseenProperties as UnseenColor).color;
    } else if (unseenProperties is UnseenGradient) {
      unSeenPaint.shader = (unseenProperties as UnseenGradient).gradient.createShader(Rect.fromCircle(center: center, radius: radius));
    }

    drawArcWithRadius(
      canvas,
      center,
      radius,
      angle,
      seenPaint,
      unSeenPaint,
      startingAngle,
      spacing,
      numberOfArc,
      alreadyWatch,
      size,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
