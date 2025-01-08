import 'package:flutter/material.dart';
import 'package:popover/src/enum_placement.dart';
import 'rectangle_with_notch_painter.dart';

class Popover extends StatefulWidget {
  final Placement placement;
  final Widget trigger;
  final bool isVisible;
  final double height;
  final double width;

  Popover({
    Key? key,
    required this.text,
    this.placement = Placement.bottom,
    required this.trigger,
    this.isVisible = false,
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.white),
    this.padding = const EdgeInsets.all(5),
    this.margin,
    this.radius = 8,
    this.shadow = 0,
    this.triangleWidth = 8,
    this.triangleHeight = 8,
    this.triangleRadius = 2,
    this.color = Colors.black,
    this.height = 35,
    this.width = 100,
  })  : assert(text.trim().isNotEmpty, 'text value must not be empty.'),
        super(key: key);

  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final double radius;
  final double shadow;
  final double triangleWidth;
  final double triangleHeight;
  final double triangleRadius;

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _triggerKey = GlobalKey();
  Offset _triggerPosition = Offset.zero;
  Size _triggerSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTriggerPosition());
  }

  void toggleVisibility() {
    _overlayEntry == null ? _showOverlay() : _hideOverlay();
  }

  void _calculateTriggerPosition() {
    final renderBox = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _triggerPosition = renderBox.localToGlobal(Offset.zero);
      _triggerSize = renderBox.size;
    }
  }

  Map<String, double?> _calculateOverlayPosition() {
    final screenSize = MediaQuery.of(context).size;

    double top = 0;
    double left = 0;
    double right = 0;
    double bottom = 0;

    switch (widget.placement) {
      case Placement.top:
        top = _triggerPosition.dy - widget.height - 20;
        left = _triggerPosition.dx + (_triggerSize.width / 2) - (widget.width / 2);
        right =
            screenSize.width - (_triggerPosition.dx + _triggerSize.width / 2 + widget.width / 2);
        bottom = screenSize.height - _triggerPosition.dy;
        break;

      case Placement.bottom:
        top = _triggerPosition.dy + _triggerSize.height;
        left = _triggerPosition.dx + (_triggerSize.width / 2) - (widget.width / 2);
        right =
            screenSize.width - (_triggerPosition.dx + _triggerSize.width / 2 + widget.width / 2);
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height - 20;
        break;

      case Placement.left:
        top = _triggerPosition.dy - (widget.height / 2);
        left = _triggerPosition.dx - widget.width - 20;
        right = screenSize.width - _triggerPosition.dx;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;
        break;

      case Placement.right:
        top = _triggerPosition.dy - (widget.height / 2);
        right = screenSize.width - (_triggerPosition.dx + _triggerSize.width + widget.width + 20);
        left = _triggerPosition.dx + _triggerSize.width;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;
        break;

      // Additional cases for start and end placements

      case Placement.topStart:
        top = _triggerPosition.dy - widget.height - 20;
        left = _triggerPosition.dx;
        right = screenSize.width - _triggerPosition.dx - widget.width;
        bottom = screenSize.height - _triggerPosition.dy;
        break;

      case Placement.topEnd:
        top = _triggerPosition.dy - widget.height - 20;
        left = _triggerPosition.dx + _triggerSize.width - widget.width;
        right = screenSize.width - (_triggerPosition.dx + _triggerSize.width);
        bottom = screenSize.height - _triggerPosition.dy;
        break;

      case Placement.leftStart:
        top = _triggerPosition.dy - (widget.height / 2);
        left = _triggerPosition.dx - widget.width - 20;
        right = screenSize.width - _triggerPosition.dx;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;

        break;

      case Placement.leftEnd:
        top = _triggerPosition.dy - (widget.height / 2);
        left = _triggerPosition.dx - widget.width - 20;
        right = screenSize.width - _triggerPosition.dx;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;
        break;

      case Placement.rightStart:
        top = _triggerPosition.dy - (widget.height / 2);
        right = screenSize.width - (_triggerPosition.dx + _triggerSize.width + widget.width + 20);
        left = _triggerPosition.dx + _triggerSize.width;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;
        break;

      case Placement.rightEnd:
        top = _triggerPosition.dy - (widget.height / 2);
        right = screenSize.width - (_triggerPosition.dx + _triggerSize.width + widget.width + 20);
        left = _triggerPosition.dx + _triggerSize.width;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height / 2;
        break;

      case Placement.bottomStart:
        top = _triggerPosition.dy + _triggerSize.height;
        left = _triggerPosition.dx;
        right = screenSize.width - _triggerPosition.dx - widget.width;
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height - 20;
        break;

      case Placement.bottomEnd:
        top = _triggerPosition.dy + _triggerSize.height;
        left = _triggerPosition.dx + _triggerSize.width - widget.width;
        right = screenSize.width - (_triggerPosition.dx + _triggerSize.width);
        bottom = screenSize.height - _triggerPosition.dy - _triggerSize.height - widget.height - 20;
        break;
    }

    return {'top': top, 'left': left, 'right': right, 'bottom': bottom};
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final overlayPosition = _calculateOverlayPosition();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: overlayPosition['top'],
          left: overlayPosition['left'],
          right: overlayPosition['right'],
          bottom: overlayPosition['bottom'],
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomPaint(
                painter: RectangleWithNotchPainter(
                  color: widget.color,
                  radius: widget.radius,
                  shadow: widget.shadow,
                  triangleWidth: widget.triangleWidth,
                  triangleHeight: widget.triangleHeight,
                  triangleRadius: widget.triangleRadius,
                  placement: widget.placement,
                ),
                child: Container(
                  padding: widget.padding,
                  margin: widget.margin,
                  child: Center(child: Text(widget.text, style: widget.textStyle)),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _triggerKey,
      onTap: toggleVisibility,
      child: widget.trigger,
    );
  }
}
