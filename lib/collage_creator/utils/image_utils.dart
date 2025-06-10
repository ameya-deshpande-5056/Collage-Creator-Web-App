import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop' as js_interop;
import 'dart:ui' as ui;
import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

String getTwoDigitFigure(int number) {
  if (number < 10) {
    return "0$number";
  } else {
    return "$number";
  }
}

String getCurrentDateTimeAsString() {
  String year = DateTime.now().year.toString();
  String month = getTwoDigitFigure(DateTime.now().month);
  String day = getTwoDigitFigure(DateTime.now().day);
  String hour = getTwoDigitFigure(DateTime.now().hour);
  String minute = getTwoDigitFigure(DateTime.now().minute);
  String second = getTwoDigitFigure(DateTime.now().second);
  return "$year$month$day$hour$minute$second";
}

class ImageUtils {
  static Future<List<Uint8List>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      return await Future.wait(images.map((img) => img.readAsBytes()));
    }
    return [];
  }

  static Future<Uint8List?> loadAssetAsUint8List(String? path) async {
    if (path == null) return null;
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  static Future<void> exportCollageToPng(GlobalKey collageKey) async {
    try {
      final boundary =
          collageKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final pngJsArray = (<web.BlobPart>[pngBytes.buffer.toJS]).toJS;
      final blob = web.Blob(pngJsArray);
      final url = web.URL.createObjectURL(blob);
      final anchor =
          web.document.createElement('a') as web.HTMLAnchorElement
            ..href = url
            ..download =
                'IMG_${collageKey.hashCode}_${getCurrentDateTimeAsString()}.png';
      anchor.click();
      web.URL.revokeObjectURL(url);
    } catch (e) {
      debugPrint('Error saving collage: $e');
    }
  }
}
