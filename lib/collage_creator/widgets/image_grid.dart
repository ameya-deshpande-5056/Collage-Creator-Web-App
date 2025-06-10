import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class ImageGrid extends StatefulWidget {
  final List<Uint8List> images;
  final Function(int, int) onReorder;
  final Function(int) onRemove;
  final int crossAxisCount;

  const ImageGrid({
    super.key,
    required this.images,
    required this.onReorder,
    required this.onRemove,
    this.crossAxisCount = 2,
  });

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  late List<Uint8List> _images;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.images);
    // _resetIndices();
  }

  @override
  void didUpdateWidget(ImageGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images) {
      _images = List.from(widget.images);
      // _resetIndices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth =
            (constraints.maxWidth - (widget.crossAxisCount - 1) * 10) /
            widget.crossAxisCount;
        final double itemHeight =
            (constraints.maxHeight - (widget.crossAxisCount - 1) * 10) /
            widget.crossAxisCount;
        final double itemLength = (itemWidth + itemHeight) / 2;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: ReorderableGridView.count(
            padding: EdgeInsets.all(12),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: widget.crossAxisCount,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final image = _images.removeAt(oldIndex);
                _images.insert(oldIndex, image);
              });
              widget.onReorder(oldIndex, newIndex);
            },
            dragWidgetBuilder:
                (index, child) => Material(
                  elevation: 8,
                  child: Transform.scale(scale: 1.1, child: child),
                ),
            dragStartDelay: Duration(milliseconds: 100),
            children:
                _images.asMap().entries.map((entry) {
                  final index = entry.key;
                  return _buildGridItem(index, itemLength);
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildGridItem(int index, double width) {
    return Container(
      key: ValueKey(index.toString()),
      width: width,
      height: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            _images[index],
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.red, size: 40),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => widget.onRemove(index),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.red.shade600, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
