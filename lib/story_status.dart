library story_status;

import 'dart:math';

import 'package:flutter/material.dart';

// Classes for seen and unseen properties
class SeenProperties {
  final Color? color;
  final Gradient? gradient;

  SeenProperties({
    this.color,
    this.gradient,
  }) : assert(
          ((color == null && gradient != null) || (color != null && gradient == null)),
          "Either color or gradient must be provided, but not both.",
        );
}

class UnseenProperties {
  final Color? color;
  final Gradient? gradient;

  UnseenProperties({
    this.color,
    this.gradient,
  }) : assert(
          ((color == null && gradient != null) || (color != null && gradient == null)),
          "Either color or gradient must be provided, but not both.",
        );
}

class StoryStatus extends StatefulWidget {
  final int numberOfStatus;
  final int countOfSeenStatus;
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
    this.countOfSeenStatus = 0,
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
    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: CustomPaint(
        painter: Arc(
          alreadyWatch: widget.countOfSeenStatus,
          numberOfArc: widget.numberOfStatus,
          spacing: widget.spacing,
          strokeWidth: widget.strokeWidth,
          seenProperties: widget.seenProperties,
          unseenProperties: widget.unseenProperties,
        ),
        child: widget.child != null
            ? SizedBox(
                width: (widget.radius * 2) - widget.padding,
                height: widget.radius * 2 - widget.padding,
                child: widget.child!,
              )
            : null,
      ),
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
      Paint paint = i < alreadyWatch ? seenPaint : unSeenPaint;

      double currentAngle = start + i * (angle + spacing);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        doubleToAngle(currentAngle),
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
    var startingAngle = (numberOfArc == 1) ? 270.0 : -90.0 + (spacing / 2);

    Paint seenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (seenProperties.color != null) {
      seenPaint.color = seenProperties.color!;
    } else if (seenProperties.gradient != null) {
      seenPaint.shader = seenProperties.gradient?.createShader(Rect.fromCircle(center: center, radius: radius));
    }

    Paint unSeenPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (unseenProperties.color != null) {
      unSeenPaint.color = unseenProperties.color!;
    } else if (unseenProperties.gradient != null) {
      unSeenPaint.shader = unseenProperties.gradient?.createShader(Rect.fromCircle(center: center, radius: radius));
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
