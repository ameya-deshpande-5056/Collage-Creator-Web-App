import '../collage_creator.dart';

class PositionedResizableText extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle? style;
  final String fontFamily;
  final Offset initialPosition;
  final Size initialSize;
  final double initialRotation;
  final void Function(Offset offset, Size size, double rotation)? onChanged;
  final void Function()? onDelete;
  final void Function(String newText)? onEdit;
  final bool isEmoji;

  const PositionedResizableText({
    super.key,
    required this.text,
    this.style,
    required this.fontFamily,
    required this.color,
    required this.initialPosition,
    required this.initialSize,
    required this.initialRotation,
    this.onChanged,
    this.onDelete,
    this.onEdit,
    this.isEmoji = false,
  });

  @override
  State<PositionedResizableText> createState() =>
      _PositionedResizableTextState();
}

class _PositionedResizableTextState extends State<PositionedResizableText> {
  late Offset position;
  late Size size;
  late double rotation;
  late String displayText;
  late TextStyle currentStyle;
  bool _isHovered = false;
  bool _isResizing = false;
  bool _isRotating = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
    size = widget.initialSize;
    rotation = widget.initialRotation;
    displayText = widget.text;
    currentStyle = widget.style ?? const TextStyle();
  }

  Offset _rotateOffset(Offset offset, double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Offset(
      offset.dx * cosAngle - offset.dy * sinAngle,
      offset.dx * sinAngle + offset.dy * cosAngle,
    );
  }

  void _showEditDialog() async {
    final controller = TextEditingController(text: displayText);
    TextStyle editedStyle = currentStyle;
    String editedFont = currentStyle.fontFamily ?? widget.fontFamily;

    final result = await showDialog<String>(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text("Edit Text/Emoji"),
                  content: SizedBox(
                    width: 326,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(controller: controller),
                        const SizedBox(height: 10),
                        TextStyleEditor(
                          initialStyle: editedStyle,
                          initialFont: editedFont,
                          onStyleChanged: (newStyle, newFont) {
                            setState(() {
                              editedStyle = newStyle;
                              editedFont = newFont;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          displayText = controller.text.trim();
                          currentStyle = editedStyle.copyWith(
                            fontFamily: editedFont,
                          );
                          debugPrint(
                            "Current font after edit: ${currentStyle.fontFamily}",
                          );
                        });
                        widget.onEdit?.call(displayText);
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
          ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() => displayText = result.trim());
      widget.onEdit?.call(displayText);
    }
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
      final newWidth = max(12.0, size.width + details.delta.dx);
      final newHeight = max(12.0, size.height + details.delta.dy);
      size = Size(newWidth, newHeight);
    });
    widget.onChanged?.call(position, size, rotation);
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
            onPanUpdate: (details) {
              if (_isResizing) return;
              final rotatedDelta = _rotateOffset(details.delta, rotation);

              setState(() => position += rotatedDelta);

              widget.onChanged?.call(position, size, rotation);
            },
            onLongPress: widget.isEmoji ? null : _showEditDialog,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 50,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height,
                        alignment: Alignment.center,
                        decoration:
                            widget.isEmoji
                                ? BoxDecoration()
                                : BoxDecoration(
                                  border:
                                      _isHovered
                                          ? Border.all(color: Colors.blueAccent)
                                          : Border.all(color: Colors.grey),
                                  color: Colors.white70,
                                ),
                        child: Text(
                          displayText,
                          style: currentStyle.copyWith(
                            fontSize:
                                widget.isEmoji
                                    ? size.height * 0.9
                                    : currentStyle.fontSize,
                            height: 0.9,
                            fontFamily:
                                currentStyle.fontFamily ?? widget.fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_isHovered)
                        Positioned(
                          top: 5,
                          left: 5,
                          child: InkWell(
                            onTap: widget.onDelete,
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 25,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
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
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Icon(Icons.drag_handle, size: 18),
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
                              width: 20,
                              height: 20,
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
                if (_isHovered && !widget.isEmoji)
                  Positioned(
                    top: 0,
                    left: 35,
                    child: Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: Text(
                        "Click & hold to edit",
                        style: TextStyle(fontSize: 10),
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
