import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

Widget getLargeHeaderText(String headerText, {double fontSize = 24}) {
  return Text(
    headerText,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

Widget getSmallHeaderText(String headerText, {double fontSize = 18}) {
  return Text(
    headerText,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

Widget getContentHeaderText(String contentText, {double fontSize = 16}) {
  return Text(contentText, style: TextStyle(fontSize: fontSize));
}
