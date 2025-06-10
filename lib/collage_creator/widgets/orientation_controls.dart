import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class OrientationControls extends StatelessWidget {
  final String orientation;
  final String largeImagePosition;
  final Function(String) onOrientationChanged;
  final Function(String) onLargeImagePositionChanged;
  final int imageCount;

  const OrientationControls({
    super.key,
    required this.orientation,
    required this.largeImagePosition,
    required this.onOrientationChanged,
    required this.onLargeImagePositionChanged,
    required this.imageCount,
  });

  @override
  Widget build(BuildContext context) {
    return dynamicRowColumnShifter(
      context,
      children: [
        if (imageCount == 2 ||
            imageCount == 3 ||
            imageCount == 5 ||
            imageCount == 6)
          Padding(
            padding: const EdgeInsets.all(4),
            child: ToggleButtons(
              isSelected: [
                orientation == horizontalOrientation,
                orientation == verticalOrientation,
              ],
              onPressed: (index) {
                onOrientationChanged(
                  index == 0 ? horizontalOrientation : verticalOrientation,
                );
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: getContentHeaderText(horizontalTxt, fontSize: 12),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: getContentHeaderText(verticalTxt, fontSize: 12),
                ),
              ],
            ),
          ),
        if (imageCount == 3 || imageCount == 5)
          Padding(
            padding: const EdgeInsets.all(4),
            child: ToggleButtons(
              isSelected: [
                largeImagePosition == startImagePosition,
                largeImagePosition == endImagePosition,
              ],
              onPressed: (index) {
                onLargeImagePositionChanged(
                  index == 0 ? startImagePosition : endImagePosition,
                );
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: getContentHeaderText(
                    orientation == horizontalOrientation ? topTxt : leftTxt,
                    fontSize: 12,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: getContentHeaderText(
                    orientation == horizontalOrientation
                        ? bottomTxt
                        : rightTxt,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
