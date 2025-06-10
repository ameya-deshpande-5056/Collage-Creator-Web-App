import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class MobileLayout extends StatelessWidget {
  final Collage collage;
  final GlobalKey collageKey;
  final Function(CollageMode?) onCollageModeChanged;
  final Function(CollageShape) onCollageShapeChanged;
  final Function(String) onOrientationChanged;
  final Function(String) onLargeImagePositionChanged;
  final Function(bool) onShowBordersChanged;
  final Function(Color) onBackgroundColorChanged;
  final Function(Uint8List?) onBackgroundImageChanged;
  final Function(BackgroundOption) onBackgroundOptionSelected;
  final Function(Color) onBorderColorChanged;
  final Function(double) onBorderWidthChanged;
  final Function(int, int) onReorderImages;
  final Function(int) onRemoveImage;

  const MobileLayout({
    super.key,
    required this.collage,
    required this.collageKey,
    required this.onCollageModeChanged,
    required this.onCollageShapeChanged,
    required this.onOrientationChanged,
    required this.onLargeImagePositionChanged,
    required this.onShowBordersChanged,
    required this.onBackgroundColorChanged,
    required this.onBackgroundImageChanged,
    required this.onBackgroundOptionSelected,
    required this.onBorderColorChanged,
    required this.onBorderWidthChanged,
    required this.onReorderImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                CollageModeController(
                  imageBytesList: collage.selectedImages,
                  collageMode: collage.mode,
                  bgColor: collage.bgColor,
                  bgImage: collage.bgImage,
                  selectedBackgroundOption: collage.bgOption,
                  collageShape: collage.shape,
                  onCollageModeChanged: onCollageModeChanged,
                  onBgColorChanged: onBackgroundColorChanged,
                  onBgImageChanged: onBackgroundImageChanged,
                  onBgOptionSelected: onBackgroundOptionSelected,
                  onCollageShapeChanged: onCollageShapeChanged,
                ),
                if (collage.mode == CollageMode.grid)
                  OrientationControls(
                    orientation: collage.orientation,
                    largeImagePosition: collage.largeImagePosition,
                    onOrientationChanged: onOrientationChanged,
                    onLargeImagePositionChanged: onLargeImagePositionChanged,
                    imageCount: collage.selectedImages.length,
                  ),
                const Spacer(),
              ],
            ),
            if (collage.mode == CollageMode.grid) ...[
              const SizedBox(height: 10),
              BorderControls(
                showBorders: collage.showBorders,
                borderColor: collage.borderColor,
                borderWidth: collage.borderWidth,
                imageCount: collage.selectedImages.length,
                onShowBordersChanged: onShowBordersChanged,
                onBorderColorChanged: onBorderColorChanged,
                onBorderWidthChanged: onBorderWidthChanged,
              ),
            ],
          ],
        ),
        Expanded(
          child: ImageGrid(
            images: collage.selectedImages,
            onReorder: onReorderImages,
            onRemove: onRemoveImage,
          ),
        ),
        const Divider(),
        getSmallHeaderText(previewTxt),
        const SizedBox(height: 5),
        SizedBox(
          height: 300,
          child: AspectRatio(
            aspectRatio: 1,
            child: CollagePreview(
              images: collage.selectedImages,
              mode: collage.mode,
              bgColor: collage.bgColor,
              bgImage: collage.bgImage,
              shape: collage.shape,
              orientation: collage.orientation,
              largeImagePosition: collage.largeImagePosition,
              showBorders: collage.showBorders,
              borderWidth: collage.borderWidth,
              borderColor: collage.borderColor,
              collageKey: collageKey,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
      ],
    );
  }
}
