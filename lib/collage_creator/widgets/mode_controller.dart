import 'package:flutter/cupertino.dart';

import '../collage_creator.dart';

class CollageModeController extends StatelessWidget {
  final List<Uint8List> imageBytesList;
  final CollageMode collageMode;
  final Color bgColor;
  final BackgroundOption selectedBackgroundOption;
  final Uint8List? bgImage;
  final double colorPickerWidth;
  final CollageShape collageShape;
  final Function(CollageMode?) onCollageModeChanged;
  final Function(Color) onBgColorChanged;
  final Function(Uint8List?) onBgImageChanged;
  final Function(BackgroundOption) onBgOptionSelected;
  final Function(CollageShape) onCollageShapeChanged;

  const CollageModeController({
    super.key,
    required this.imageBytesList,
    required this.collageMode,
    required this.bgColor,
    this.bgImage,
    this.colorPickerWidth = 300,
    required this.collageShape,
    required this.onCollageModeChanged,
    required this.onBgColorChanged,
    required this.onBgImageChanged,
    required this.onBgOptionSelected,
    required this.onCollageShapeChanged,
    required this.selectedBackgroundOption,
  });

  @override
  Widget build(BuildContext context) {
    return imageBytesList.length > 1
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoSlidingSegmentedControl(
              groupValue: collageMode,
              onValueChanged: onCollageModeChanged,
              children: const {
                CollageMode.freeform: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Freeform", style: TextStyle(fontSize: 12)),
                ),
                CollageMode.grid: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Grid", style: TextStyle(fontSize: 12)),
                ),
              },
            ),
            if (selectedBackgroundOption == BackgroundOption.none) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getContentHeaderText("Background Color:", fontSize: 14),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: getSmallHeaderText(
                                "Choose Background Color",
                              ),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: bgColor,
                                  onColorChanged: onBgColorChanged,
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
                        color: bgColor,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            dynamicRowColumnShifter(
              context,
              children: [
                SizedBox(width: 20),
                Text('Background: '),
                SizedBox(width: 10),
                DropdownButton<BackgroundOption>(
                  value: selectedBackgroundOption,
                  onChanged: (BackgroundOption? newValue) {
                    if (newValue != null) {
                      onBgOptionSelected(newValue);
                    }
                  },
                  items:
                      BackgroundOption.values.map((BackgroundOption option) {
                        return DropdownMenuItem<BackgroundOption>(
                          value: option,
                          child: Text(switch (option) {
                            BackgroundOption.none => 'No background (plain)',
                            BackgroundOption.template1 =>
                              'Background Template 1',
                            BackgroundOption.template2 =>
                              'Background Template 2',
                            BackgroundOption.template3 =>
                              'Background Template 3',
                            BackgroundOption.template4 =>
                              'Background Template 4',
                          }),
                        );
                      }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (collageMode == CollageMode.freeform)
              CupertinoSegmentedControl(
                groupValue: collageShape,
                onValueChanged: onCollageShapeChanged,
                children: const {
                  CollageShape.rectangle: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Rectangular", style: TextStyle(fontSize: 12)),
                  ),
                  CollageShape.hexagon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Hexagonal", style: TextStyle(fontSize: 12)),
                  ),
                  CollageShape.circle: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Circular", style: TextStyle(fontSize: 12)),
                  ),
                  CollageShape.mixed: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Mixed", style: TextStyle(fontSize: 12)),
                  ),
                },
              ),
            const SizedBox(height: 12),
          ],
        )
        : SizedBox.shrink();
  }
}
