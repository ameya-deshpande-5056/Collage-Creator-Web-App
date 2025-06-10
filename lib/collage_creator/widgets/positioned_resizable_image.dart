import '../collage_creator.dart';

class PositionedResizableImage extends StatefulWidget {
  final Offset initialPosition;
  final Size initialSize;
  final double initialRotation;
  final Uint8List imageBytes;
  final void Function(Offset, Size, double) onChanged;
  final CollageShape collageShape;
  final int index;

  const PositionedResizableImage({
    required this.initialPosition,
    required this.initialSize,
    required this.initialRotation,
    required this.imageBytes,
    required this.onChanged,
    required this.collageShape,
    required this.index,
    super.key,
  });

  @override
  State<PositionedResizableImage> createState() =>
      _PositionedResizableImageState();
}

class _PositionedResizableImageState extends State<PositionedResizableImage> {
  late Offset position;
  late Size size;
  late double rotation;
  bool _isHovered = false;
  bool _isResizing = false;
  bool _isRotating = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
    size = widget.initialSize;
    rotation = widget.initialRotation;
  }

  Offset _rotateOffset(Offset offset, double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Offset(
      offset.dx * cosAngle - offset.dy * sinAngle,
      offset.dx * sinAngle + offset.dy * cosAngle,
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isResizing) return;
    final rotatedDelta = _rotateOffset(details.delta, rotation);

    setState(() {
      position += rotatedDelta;
    });
    widget.onChanged(position, size, rotation);
  }

  void _onResizeStart() {
    setState(() {
      _isResizing = true;
    });
  }

  void _onResizeEnd(_) {
    setState(() {
      _isResizing = false;
    });
  }

  void _onResizeUpdate(DragUpdateDetails details) {
    setState(() {
      _isResizing = true;
      final newWidth = max(50.0, size.width + details.delta.dx);
      final newHeight = max(50.0, size.height + details.delta.dy);
      size = Size(newWidth, newHeight);
    });
    widget.onChanged(position, size, rotation);
  }

  void _onRotateStart(_) {
    setState(() => _isRotating = true);
  }

  void _onRotateUpdate(DragUpdateDetails details) {
    setState(() {
      _isRotating = true;
      rotation +=
          ((details.delta.dx + details.delta.dy) / 2) *
          0.01; // tweak sensitivity if needed
    });
  }

  void _onRotateEnd(_) {
    setState(() => _isRotating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: rotation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) {
            if (!_isResizing && !_isRotating) {
              setState(() => _isHovered = false);
            }
          },
          child: GestureDetector(
            onPanUpdate: _onDragUpdate,
            child: Stack(
              children: [
                if (widget.collageShape == CollageShape.hexagon)
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      border:
                          _isHovered
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                    ),
                    child: buildHexagonalImage(widget.imageBytes, size.width),
                  ),
                if (widget.collageShape == CollageShape.rectangle)
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(widget.imageBytes),
                        fit: BoxFit.cover,
                      ),
                      border:
                          _isHovered
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                    ),
                  ),
                if (widget.collageShape == CollageShape.circle)
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(widget.imageBytes),
                        fit: BoxFit.fill,
                      ),
                      border:
                          _isHovered
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                    ),
                  ),
                if (widget.collageShape == CollageShape.mixed) ...[
                  if (widget.index % 3 == 0)
                    Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: MemoryImage(widget.imageBytes),
                          fit: BoxFit.cover,
                        ),
                        border:
                            _isHovered
                                ? Border.all(color: Colors.blueAccent)
                                : null,
                      ),
                    ),
                  if (widget.index % 3 == 1)
                    Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        border:
                            _isHovered
                                ? Border.all(color: Colors.blueAccent)
                                : null,
                      ),
                      child: buildHexagonalImage(widget.imageBytes, size.width),
                    ),
                  if (widget.index % 3 == 2)
                    Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(widget.imageBytes),
                          fit: BoxFit.fill,
                        ),
                        border:
                            _isHovered
                                ? Border.all(color: Colors.blueAccent)
                                : null,
                      ),
                    ),
                ],
                if (_isHovered || _isResizing)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) => _onResizeStart,
                      onPanEnd: _onResizeEnd,
                      onPanCancel: () => _onResizeEnd(null),
                      onPanUpdate: _onResizeUpdate,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Icon(Icons.drag_handle, size: 24),
                      ),
                    ),
                  ),
                if (_isHovered || _isRotating)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onPanStart: _onRotateStart,
                      onPanUpdate: _onRotateUpdate,
                      onPanEnd: _onRotateEnd,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Icon(Icons.rotate_right, size: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
