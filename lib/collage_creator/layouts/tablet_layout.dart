import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class TabletLayout extends StatelessWidget {
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

  const TabletLayout({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.2,
          child: Column(
            children: [
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
              if (collage.mode == CollageMode.grid) ...[
                OrientationControls(
                  orientation: collage.orientation,
                  largeImagePosition: collage.largeImagePosition,
                  onOrientationChanged: onOrientationChanged,
                  onLargeImagePositionChanged: onLargeImagePositionChanged,
                  imageCount: collage.selectedImages.length,
                ),
                const SizedBox(height: 10),
                BorderControls(
                  showBorders: collage.showBorders,
                  borderColor: collage.borderColor,
                  borderWidth: collage.borderWidth,
                  imageCount: collage.selectedImages.length,
                  colorPickerWidth:
                      MediaQuery.sizeOf(context).width < 700 ? 190 : 300,
                  onShowBordersChanged: onShowBordersChanged,
                  onBorderColorChanged: onBorderColorChanged,
                  onBorderWidthChanged: onBorderWidthChanged,
                ),
              ],
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: ImageGrid(
                    images: collage.selectedImages,
                    onReorder: onReorderImages,
                    onRemove: onRemoveImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.79,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getSmallHeaderText(previewTxt),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * 0.4,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width:
                          MediaQuery.sizeOf(context).width *
                              (collage.mode == CollageMode.freeform
                                  ? 0.75
                                  : 0.4),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
