import '../collage_creator.dart';

Widget buildImageWithBorder(
  Uint8List img,
  Color bgColor,
  bool showBorders,
  Color borderColor,
  double borderWidth, {
  Uint8List? bgImage,
  bool top = true,
  bool right = true,
  bool bottom = true,
  bool left = true,
}) {
  return Container(
    decoration:
        showBorders
            ? BoxDecoration(
              // border: Border.all(width: borderWidth, color: borderColor),
              color: bgColor,
              image: DecorationImage(
                image:
                    bgImage != null
                        ? MemoryImage(bgImage)
                        : AssetImage(transparentBgPath),
                fit: BoxFit.fill,
              ),
              border: Border(
                top: BorderSide(
                  color: borderColor,
                  width: top ? borderWidth : borderWidth / 2,
                ),
                right: BorderSide(
                  color: borderColor,
                  width: right ? borderWidth : borderWidth / 2,
                ),
                bottom: BorderSide(
                  color: borderColor,
                  width: bottom ? borderWidth : borderWidth / 2,
                ),
                left: BorderSide(
                  color: borderColor,
                  width: left ? borderWidth : borderWidth / 2,
                ),
              ),
            )
            : null,
    child: Image.memory(img, fit: BoxFit.contain),
  );
}
