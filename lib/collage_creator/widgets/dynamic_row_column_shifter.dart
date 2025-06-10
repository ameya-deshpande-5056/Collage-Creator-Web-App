import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

Widget dynamicRowColumnShifter(
  BuildContext context, {
  required List<Widget> children,
  double thresholdWidth = 1348,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  if (screenWidth > thresholdWidth) {
    return Row(children: children);
  } else {
    return Column(children: children);
  }
}

Widget dynamicSizedBox(
  BuildContext context, {
  required double widthOrHeight,
  double thresholdWidth = 1348,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  if (screenWidth > thresholdWidth) {
    return SizedBox(width: widthOrHeight);
  } else {
    return SizedBox(height: widthOrHeight);
  }
}
