import 'package:flutter/material.dart';
import 'package:popover/src/enum_placement.dart';

/// class [RectangleWithNotchPainter]
class RectangleWithNotchPainter extends CustomPainter {
  final Placement placement;

  /// Paintes a shape (rectangle by default) with a small notch
  /// below the shape.
  ///
  ///
  const RectangleWithNotchPainter({
    required this.color,
    required this.radius,
    required this.shadow,
    required this.triangleWidth,
    required this.triangleHeight,
    required this.triangleRadius,
    required this.placement,
  });

  /// The color of the painted shape.
  final Color color;

  /// The radius value for the edges of the shape (aka: border radius).
  final double radius;

  /// The box shadow behind the painted shape.
  final double shadow;

  /// The notch width.
  final double triangleWidth;

  /// The notch height.
  final double triangleHeight;

  /// The radius for the edges of the notch.
  final double triangleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // rectangle lines points (left, bottom. right, top)
    final Offset leftLineStartPoint = Offset(0, radius);
    final Offset leftLineEndPoint = Offset(0, size.height - radius);

    final Offset bottomLineStartPoint = Offset(radius, size.height);
    final Offset bottomLineEndPoint = Offset(size.width - radius, size.height);

    final Offset rightLineStartPoint = Offset(size.width, size.height - radius);
    final Offset rightLineEndPoint = Offset(size.width, radius);

    final Offset topLineStartPoint = Offset(size.width - radius, 0);
    final Offset topLineEndPoint = Offset(radius, 0);

    // rectangle control points
    final Offset topLeftControlPoint = Offset.zero;
    final Offset bottomLeftControlPoint = Offset(0, size.height);
    final Offset topRightControlPoint = Offset(size.width, 0);
    final Offset bottomRightControlPoint = Offset(size.width, size.height);

    // triangle points
    final Offset bottomCenterStartPoint =
        Offset((size.width / 2) - triangleWidth - triangleRadius, size.height);
    final Offset bottomCenterStartPoint2 =
        Offset((size.width / 2) - triangleWidth + triangleRadius, size.height + triangleRadius);

    final Offset bottomCenterMiddlePoint =
        Offset((size.width / 2) - triangleRadius, size.height + triangleHeight - triangleRadius);
    final Offset bottomCenterMiddlePoint2 =
        Offset((size.width / 2) + triangleRadius, size.height + triangleHeight - triangleRadius);

    final Offset bottomCenterEndPoint =
        Offset((size.width / 2) + triangleWidth - triangleRadius, size.height + triangleRadius);
    final Offset bottomCenterEndPoint2 =
        Offset((size.width / 2) + triangleWidth + triangleRadius, size.height);

    // triangle control points
    final Offset bottomCenterStartControlPoint =
        Offset((size.width / 2) - triangleWidth, size.height);
    final Offset bottomCenterMiddleControlPoint =
        Offset(size.width / 2, size.height + triangleHeight);
    final Offset bottomCenterEndControlPoint =
        Offset((size.width / 2) + triangleWidth, size.height);

    final Paint paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, shadow);

    final Path path = Path();

    switch (placement) {
      case Placement.bottom:
        path
          ..moveTo(leftLineStartPoint.dx, leftLineStartPoint.dy)
          ..lineTo(leftLineEndPoint.dx, leftLineEndPoint.dy)
          ..quadraticBezierTo(bottomLeftControlPoint.dx, bottomLeftControlPoint.dy,
              bottomLineStartPoint.dx, bottomLineStartPoint.dy)
          ..lineTo(bottomCenterStartPoint.dx, bottomCenterStartPoint.dy)
          ..quadraticBezierTo(bottomCenterStartControlPoint.dx, bottomCenterStartControlPoint.dy,
              bottomCenterStartPoint2.dx, bottomCenterStartPoint2.dy)
          ..lineTo(bottomCenterMiddlePoint.dx, bottomCenterMiddlePoint.dy)
          ..quadraticBezierTo(bottomCenterMiddleControlPoint.dx, bottomCenterMiddleControlPoint.dy,
              bottomCenterMiddlePoint2.dx, bottomCenterMiddlePoint2.dy)
          ..lineTo(bottomCenterEndPoint.dx, bottomCenterEndPoint.dy)
          ..quadraticBezierTo(bottomCenterEndControlPoint.dx, bottomCenterEndControlPoint.dy,
              bottomCenterEndPoint2.dx, bottomCenterEndPoint2.dy)
          ..lineTo(bottomLineEndPoint.dx, bottomLineEndPoint.dy)
          ..quadraticBezierTo(bottomRightControlPoint.dx, bottomRightControlPoint.dy,
              rightLineStartPoint.dx, rightLineStartPoint.dy)
          ..lineTo(rightLineEndPoint.dx, rightLineEndPoint.dy)
          ..quadraticBezierTo(topRightControlPoint.dx, topRightControlPoint.dy,
              topLineStartPoint.dx, topLineStartPoint.dy)
          ..lineTo(topLineEndPoint.dx, topLineEndPoint.dy)
          ..quadraticBezierTo(topLeftControlPoint.dx, topLeftControlPoint.dy, leftLineStartPoint.dx,
              leftLineStartPoint.dy);
        break;
      case Placement.top:
        path
          ..moveTo(0, radius)
          ..lineTo(0, size.height - radius)
          ..quadraticBezierTo(0, size.height, radius, size.height)
          ..lineTo(size.width - radius, size.height)
          ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
          ..lineTo(size.width, radius)
          ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
          ..lineTo((size.width / 2) + triangleWidth, 0)
          ..lineTo((size.width / 2), -triangleHeight)
          ..lineTo((size.width / 2) - triangleWidth, 0)
          ..lineTo(radius, 0)
          ..quadraticBezierTo(0, 0, 0, radius);
        break;
      case Placement.left:
        path
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, radius)
          ..lineTo(size.width, size.height - radius)
          ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
          ..lineTo(radius, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - radius)
          ..lineTo(0, (size.height / 2) + triangleWidth)
          ..lineTo(-triangleHeight, (size.height / 2))
          ..lineTo(0, (size.height / 2) - triangleWidth)
          ..lineTo(0, radius)
          ..quadraticBezierTo(0, 0, radius, 0);
        break;
      case Placement.right:
        path
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, radius)
          ..lineTo(size.width, (size.height / 2) - triangleWidth)
          ..lineTo(size.width + triangleHeight, (size.height / 2))
          ..lineTo(size.width, (size.height / 2) + triangleWidth)
          ..lineTo(size.width, size.height - radius)
          ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
          ..lineTo(radius, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - radius)
          ..lineTo(0, radius)
          ..quadraticBezierTo(0, 0, radius, 0);
        break;

      case Placement.topStart:
        // Notch ở cạnh trên bên trái
        path
          ..moveTo(0, radius)
          ..lineTo(0, size.height - radius)
          ..quadraticBezierTo(0, size.height, radius, size.height)
          ..lineTo(size.width - radius, size.height)
          ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
          ..lineTo(size.width, radius)
          ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
          ..lineTo(triangleWidth * 2, 0)
          ..lineTo(triangleWidth, -triangleHeight)
          ..lineTo(0, 0)
          ..quadraticBezierTo(0, 0, 0, radius);
        break;

      case Placement.topEnd:
        // Notch ở cạnh trên bên phải
        path
          ..moveTo(0, radius)
          ..lineTo(0, size.height - radius)
          ..quadraticBezierTo(0, size.height, radius, size.height)
          ..lineTo(size.width - radius, size.height)
          ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
          ..lineTo(size.width, radius)
          ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
          ..lineTo(size.width - triangleWidth, 0)
          ..lineTo(size.width - triangleWidth * 2, -triangleHeight)
          ..lineTo(size.width, 0)
          ..lineTo(radius, 0)
          ..quadraticBezierTo(0, 0, 0, radius);
        break;

      default:
        // default bottom
        path
          ..moveTo(leftLineStartPoint.dx, leftLineStartPoint.dy)
          ..lineTo(leftLineEndPoint.dx, leftLineEndPoint.dy)
          ..quadraticBezierTo(bottomLeftControlPoint.dx, bottomLeftControlPoint.dy,
              bottomLineStartPoint.dx, bottomLineStartPoint.dy)
          ..lineTo(bottomCenterStartPoint.dx, bottomCenterStartPoint.dy)
          ..quadraticBezierTo(bottomCenterStartControlPoint.dx, bottomCenterStartControlPoint.dy,
              bottomCenterStartPoint2.dx, bottomCenterStartPoint2.dy)
          ..lineTo(bottomCenterMiddlePoint.dx, bottomCenterMiddlePoint.dy)
          ..quadraticBezierTo(bottomCenterMiddleControlPoint.dx, bottomCenterMiddleControlPoint.dy,
              bottomCenterMiddlePoint2.dx, bottomCenterMiddlePoint2.dy)
          ..lineTo(bottomCenterEndPoint.dx, bottomCenterEndPoint.dy)
          ..quadraticBezierTo(bottomCenterEndControlPoint.dx, bottomCenterEndControlPoint.dy,
              bottomCenterEndPoint2.dx, bottomCenterEndPoint2.dy)
          ..lineTo(bottomLineEndPoint.dx, bottomLineEndPoint.dy)
          ..quadraticBezierTo(bottomRightControlPoint.dx, bottomRightControlPoint.dy,
              rightLineStartPoint.dx, rightLineStartPoint.dy)
          ..lineTo(rightLineEndPoint.dx, rightLineEndPoint.dy)
          ..quadraticBezierTo(topRightControlPoint.dx, topRightControlPoint.dy,
              topLineStartPoint.dx, topLineStartPoint.dy)
          ..lineTo(topLineEndPoint.dx, topLineEndPoint.dy)
          ..quadraticBezierTo(topLeftControlPoint.dx, topLeftControlPoint.dy, leftLineStartPoint.dx,
              leftLineStartPoint.dy);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RectangleWithNotchPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(RectangleWithNotchPainter oldDelegate) => false;
}
