import 'package:flutter/material.dart';

/// Compact sparkline with optional gradient fill beneath the line.
class MiniLineChart extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final bool showGradient;

  const MiniLineChart({
    super.key,
    required this.data,
    required this.lineColor,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const SizedBox.shrink();

    return CustomPaint(
      painter: _MiniLineChartPainter(
        data: data,
        lineColor: lineColor,
        showGradient: showGradient,
        isRtl: Directionality.of(context) == TextDirection.rtl,
      ),
      size: Size.infinite,
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final bool showGradient;
  final bool isRtl;

  _MiniLineChartPainter({
    required this.data,
    required this.lineColor,
    required this.showGradient,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = _normalizedPoints(size);
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    if (showGradient) {
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.35),
            lineColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  List<Offset> _normalizedPoints(Size size) {
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).clamp(0.01, double.infinity);
    final stepX = size.width / (data.length - 1);

    return List.generate(data.length, (index) {
      final logicalIndex = isRtl ? data.length - 1 - index : index;
      final x = logicalIndex * stepX;
      final normalized = (data[index] - minY) / range;
      final y = size.height - (normalized * size.height * 0.85) - size.height * 0.075;
      return Offset(x, y);
    });
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.showGradient != showGradient ||
        oldDelegate.isRtl != isRtl;
  }
}
