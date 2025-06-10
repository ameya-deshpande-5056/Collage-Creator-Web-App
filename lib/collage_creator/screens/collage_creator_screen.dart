@js_interop.JS()
library;

import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:js_interop' as js_interop;

class CollageCreatorScreen extends StatefulWidget {
  const CollageCreatorScreen({super.key});

  @override
  State<CollageCreatorScreen> createState() => _CollageCreatorScreenState();
}

class _CollageCreatorScreenState extends State<CollageCreatorScreen> {
  final GlobalKey collageKey = GlobalKey();
  late Collage collage;
  late BackgroundOption selectedBackgroundOption;

  @override
  void initState() {
    super.initState();
    collage = Collage();
    selectedBackgroundOption = collage.bgOption;
  }

  Future<void> pickImages() async {
    final imageBytes = await ImageUtils.pickMultipleImages();

    setState(() {
      final remainingSlots = 6 - collage.selectedImages.length;
      if (remainingSlots > 0) {
        List<Uint8List> newImages = List.from(collage.selectedImages);
        newImages.addAll(imageBytes.take(remainingSlots));
        collage = collage.copyWith(selectedImages: newImages);
      }
    });
  }

  void reorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final images = List<Uint8List>.from(collage.selectedImages);
      final item = images.removeAt(oldIndex);
      images.insert(newIndex, item);
      collage = collage.copyWith(selectedImages: images);
    });
  }

  void removeImage(int index) {
    setState(() {
      final images = List<Uint8List>.from(collage.selectedImages);
      images.removeAt(index);
      collage = collage.copyWith(selectedImages: images);
    });
  }

  void setMode(CollageMode? newCollageMode) {
    setState(() {
      collage = collage.copyWith(mode: newCollageMode);
    });
  }

  void setBackgroundColor(Color newBgColor) {
    setState(() {
      collage = collage.copyWith(bgColor: newBgColor);
    });
  }

  void setBackgroundImage(Uint8List? newBgImage) {
    setState(() {
      collage = collage.copyWith(bgImage: newBgImage);
    });
  }

  Future<void> setBackgroundOption(BackgroundOption newOption) async {
    final path = backgroundOptions[newOption];
    final bgImage = await ImageUtils.loadAssetAsUint8List(path);
    setState(() {
      selectedBackgroundOption = newOption;
      collage = collage.copyWith(bgImage: bgImage, bgOption: newOption);
    });
  }

  void setShape(CollageShape newCollageShape) {
    setState(() {
      collage = collage.copyWith(shape: newCollageShape);
    });
  }

  void setOrientation(String newOrientation) {
    setState(() {
      collage = collage.copyWith(orientation: newOrientation);
    });
  }

  void setLargeImagePosition(String newPosition) {
    setState(() {
      collage = collage.copyWith(largeImagePosition: newPosition);
    });
  }

  void setShowBorders(bool show) {
    setState(() {
      collage = collage.copyWith(showBorders: show);
    });
  }

  void setBorderColor(Color color) {
    setState(() {
      collage = collage.copyWith(borderColor: color);
    });
  }

  void setBorderWidth(double width) {
    setState(() {
      collage = collage.copyWith(borderWidth: width);
    });
  }

  Future<void> exportCollageAsImage() async {
    if (collage.selectedImages.length >= 2) {
      await ImageUtils.exportCollageToPng(collageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getLargeHeaderText(collageCreatorHeader), Divider()],
        ),
        actions: [
          if (collage.selectedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              tooltip: addImagesTxt,
              onPressed: collage.selectedImages.length < 6 ? pickImages : null,
              color:
                  collage.selectedImages.length < 6
                      ? Colors.grey.shade800
                      : Colors.white54,
              mouseCursor:
                  collage.selectedImages.length < 6
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
            ),
          if (collage.selectedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: saveCollageTxt,
              onPressed:
                  collage.selectedImages.length >= 2
                      ? exportCollageAsImage
                      : null,
              color:
                  collage.selectedImages.length >= 2
                      ? Colors.grey.shade800
                      : Colors.white54,
              mouseCursor:
                  collage.selectedImages.length >= 2
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
            ),
        ],
      ),
      body:
          collage.selectedImages.isEmpty
              ? EmptyState(onPickImages: pickImages)
              : ScreenTypeLayout.builder(
                breakpoints: ScreenBreakpoints(
                  desktop: 1200,
                  tablet: 600,
                  watch: 350,
                ),
                mobile:
                    (context) => MobileLayout(
                      collage: collage,
                      collageKey: collageKey,
                      onCollageModeChanged: setMode,
                      onCollageShapeChanged: setShape,
                      onOrientationChanged: setOrientation,
                      onLargeImagePositionChanged: setLargeImagePosition,
                      onShowBordersChanged: setShowBorders,
                      onBackgroundColorChanged: setBackgroundColor,
                      onBackgroundImageChanged: setBackgroundImage,
                      onBackgroundOptionSelected: setBackgroundOption,
                      onBorderColorChanged: setBorderColor,
                      onBorderWidthChanged: setBorderWidth,
                      onReorderImages: reorderImages,
                      onRemoveImage: removeImage,
                    ),
                tablet:
                    (context) => TabletLayout(
                      collage: collage,
                      collageKey: collageKey,
                      onCollageModeChanged: setMode,
                      onCollageShapeChanged: setShape,
                      onOrientationChanged: setOrientation,
                      onLargeImagePositionChanged: setLargeImagePosition,
                      onShowBordersChanged: setShowBorders,
                      onBackgroundColorChanged: setBackgroundColor,
                      onBackgroundImageChanged: setBackgroundImage,
                      onBackgroundOptionSelected: setBackgroundOption,
                      onBorderColorChanged: setBorderColor,
                      onBorderWidthChanged: setBorderWidth,
                      onReorderImages: reorderImages,
                      onRemoveImage: removeImage,
                    ),
                desktop:
                    (context) => DesktopLayout(
                      collage: collage,
                      collageKey: collageKey,
                      onCollageModeChanged: setMode,
                      onCollageShapeChanged: setShape,
                      onOrientationChanged: setOrientation,
                      onLargeImagePositionChanged: setLargeImagePosition,
                      onShowBordersChanged: setShowBorders,
                      onBackgroundColorChanged: setBackgroundColor,
                      onBackgroundImageChanged: setBackgroundImage,
                      onBackgroundOptionSelected: setBackgroundOption,
                      onBorderColorChanged: setBorderColor,
                      onBorderWidthChanged: setBorderWidth,
                      onReorderImages: reorderImages,
                      onRemoveImage: removeImage,
                    ),
              ),
    );
  }
}
