import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class BorderControls extends StatelessWidget {
  final bool showBorders;
  final Color borderColor;
  final double borderWidth;
  final double colorPickerWidth;
  final int imageCount;
  final Function(bool) onShowBordersChanged;
  final Function(Color) onBorderColorChanged;
  final Function(double) onBorderWidthChanged;

  const BorderControls({
    super.key,
    required this.showBorders,
    required this.borderColor,
    required this.borderWidth,
    required this.imageCount,
    required this.onShowBordersChanged,
    required this.onBorderColorChanged,
    required this.onBorderWidthChanged,
    this.colorPickerWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    return imageCount > 1
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Checkbox(
                    value: showBorders,
                    onChanged: (value) {
                      onShowBordersChanged(value ?? true);
                    },
                  ),
                  getContentHeaderText(showBordersTxt, fontSize: 14),
                  const SizedBox(width: 16),
                  if (showBorders) ...[
                    getContentHeaderText(colorTxt, fontSize: 14),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: getSmallHeaderText(chooseBorderColorTxt),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: borderColor,
                                    onColorChanged: onBorderColorChanged,
                                    enableAlpha: false,
                                    labelTypes: const [],
                                    colorPickerWidth: colorPickerWidth,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: getContentHeaderText(okTxt),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: borderColor,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showBorders)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getContentHeaderText(widthTxt, fontSize: 14),
                    SizedBox(
                      width:
                          ((MediaQuery.sizeOf(context).width +
                                  MediaQuery.sizeOf(context).height) /
                              2) *
                          0.15,
                      child: Slider(
                        value: borderWidth,
                        min: 1,
                        max: 100,
                        divisions: 99,
                        label: borderWidth.round().toString(),
                        onChanged: onBorderWidthChanged,
                      ),
                    ),
                    getContentHeaderText(
                      '${borderWidth.round()}px',
                      fontSize: 14,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
          ],
        )
        : SizedBox.shrink();
  }
}
