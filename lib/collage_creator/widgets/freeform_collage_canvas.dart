import '../collage_creator.dart';

class FreeformCollageCanvas extends StatefulWidget {
  final GlobalKey collageKey;
  final Color bgColor;
  final Uint8List? bgImage;
  final List<Uint8List> imageBytesList;
  final CollageShape collageShape;

  const FreeformCollageCanvas({
    super.key,
    required this.collageKey,
    required this.bgColor,
    this.bgImage,
    required this.imageBytesList,
    required this.collageShape,
  });

  @override
  State<FreeformCollageCanvas> createState() => _FreeformCollageCanvasState();
}

class _FreeformCollageCanvasState extends State<FreeformCollageCanvas> {
  final Map<int, Offset> positions = {};
  final Map<int, Size> sizes = {};
  final Map<int, double> rotations = {};
  final List<FreeformItem> textEmojiData = [];

  void addTextOrEmoji(
    String content, {
    Color color = Colors.black,
    TextStyle? style,
    String fontFamily = 'Roboto',
    bool isEmoji = false,
  }) {
    debugPrint("Inside addTextOrEmoji: $fontFamily");
    setState(() {
      debugPrint("Inside setState of addTextOrEmoji (before adding): $fontFamily");
      textEmojiData.add(
        FreeformItem(
          content: content,
          color: color,
          style: style,
          fontFamily: fontFamily,
          position: Offset(50 + textEmojiData.length * 10, 50),
          size: const Size(150, 75),
          rotation: 0.0,
          isEmoji: isEmoji,
        ),
      );
      debugPrint("Inside setState of addTextOrEmoji (after adding): $fontFamily");
    });
  }

  @override
  void initState() {
    super.initState();
    final initialSize = Size(150, 150);
    for (int i = 0; i < widget.imageBytesList.length; i++) {
      positions[i] = Offset(30.0 * i, 30.0 * i);
      sizes[i] = initialSize;
      rotations[i] = 0.0;
    }
  }

  @override
  void didUpdateWidget(covariant FreeformCollageCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    final initialSize = const Size(150, 150);
    final initialRotation = 0.0;
    for (int i = 0; i < widget.imageBytesList.length; i++) {
      positions.putIfAbsent(i, () => Offset(30.0 * i, 30.0 * i));
      sizes.putIfAbsent(i, () => initialSize);
      rotations.putIfAbsent(i, () => initialRotation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageBytesList.length > 1
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              key: widget.collageKey,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.45,
                height: MediaQuery.sizeOf(context).width * 0.45,
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  image: DecorationImage(
                    image:
                        widget.bgImage != null
                            ? MemoryImage(widget.bgImage!)
                            : AssetImage(transparentBgPath),
                    fit: BoxFit.fill
                  ),
                ),
                child: Stack(
                  children: [
                    ...widget.imageBytesList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final bytes = entry.value;
                      return PositionedResizableImage(
                        key: ValueKey(index),
                        initialPosition: positions[index]!,
                        initialSize: sizes[index]!,
                        initialRotation: rotations[index]!,
                        imageBytes: bytes,
                        onChanged: (offset, size, rotation) {
                          setState(() {
                            positions[index] = offset;
                            sizes[index] = size;
                            rotations[index] = rotation;
                          });
                        },
                        collageShape: widget.collageShape,
                        index: index,
                      );
                    }),
                    ...textEmojiData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return PositionedResizableText(
                        key: ValueKey("text_$index"),
                        text: item.content,
                        color: item.color,
                        style:
                            item.style ??
                            TextStyle(),
                        fontFamily: item.fontFamily,
                        initialPosition: item.position,
                        initialSize: item.size,
                        initialRotation: item.rotation,
                        onChanged: (offset, size, rotation) {
                          setState(() {
                            item.position = offset;
                            item.size = size;
                            item.rotation = rotation;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            textEmojiData.removeAt(index);
                          });
                        },
                        onEdit: (newText) {
                          setState(() {
                            item.content = newText;
                          });
                        },
                        isEmoji: item.isEmoji,
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width * 0.02),
            VerticalDivider(width: 1),
            SizedBox(width: MediaQuery.sizeOf(context).width * 0.02),
            SizedBox(
              width:
                  MediaQuery.sizeOf(context).width *
                  (MediaQuery.sizeOf(context).width > 1150 ? 0.2 : 0.25) + 4,
              child: TextEmojiPanel(
                onTextAdd:
                    (text, color, style, font) => addTextOrEmoji(
                      text,
                      color: color,
                      style: style,
                      fontFamily: font,
                      isEmoji: false,
                    ),
                onEmojiAdd: (emoji) => addTextOrEmoji(emoji, isEmoji: true),
              ),
            ),
          ],
        )
        : Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            height: 800,
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                getSmallHeaderText(pickAtLeastOneImgTxt),
                const Spacer(),
              ],
            ),
          ),
        );
  }
}
