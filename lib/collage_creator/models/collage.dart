import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class Collage {
  List<Uint8List> selectedImages;
  CollageMode mode;
  Color bgColor;
  Uint8List? bgImage;
  BackgroundOption bgOption;
  CollageShape shape;
  String orientation;
  String largeImagePosition;
  bool showBorders;
  double borderWidth;
  Color borderColor;

  Collage({
    this.selectedImages = const [],
    this.mode = CollageMode.freeform,
    this.bgColor = Colors.white,
    this.bgImage,
    this.bgOption = BackgroundOption.none,
    this.shape = CollageShape.rectangle,
    this.orientation = horizontalOrientation,
    this.largeImagePosition = startImagePosition,
    this.showBorders = true,
    this.borderWidth = 5.0,
    this.borderColor = Colors.white,
  });

  Collage copyWith({
    List<Uint8List>? selectedImages,
    CollageMode? mode,
    Color? bgColor,
    Uint8List? bgImage,
    BackgroundOption? bgOption,
    CollageShape? shape,
    String? orientation,
    String? largeImagePosition,
    bool? showBorders,
    double? borderWidth,
    Color? borderColor,
  }) {
    return Collage(
      selectedImages: selectedImages ?? this.selectedImages,
      mode: mode ?? this.mode,
      bgColor: bgColor ?? this.bgColor,
      bgImage: bgImage ?? this.bgImage,
      bgOption: bgOption ?? this.bgOption,
      shape: shape ?? this.shape,
      orientation: orientation ?? this.orientation,
      largeImagePosition: largeImagePosition ?? this.largeImagePosition,
      showBorders: showBorders ?? this.showBorders,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}
