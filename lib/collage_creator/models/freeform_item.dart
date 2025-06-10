import '../collage_creator.dart';

enum FreeformItemType { text, emoji }

class FreeformItem {
  String content;
  Color color;
  Offset position;
  Size size;
  double rotation;
  bool isEmoji;
  TextStyle? style;
  String fontFamily;

  FreeformItem({
    required this.content,
    required this.color,
    required this.position,
    required this.size,
    required this.rotation,
    required this.isEmoji,
    this.style,
    this.fontFamily = 'Roboto',
  });

  FreeformItem copyWith({
    String? content,
    Color? color,
    Offset? position,
    Size? size,
    double? rotation,
    bool? isEmoji,
    TextStyle? style,
    String? fontFamily,
  }) {
    return FreeformItem(
      content: content ?? this.content,
      color: color ?? this.color,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      isEmoji: isEmoji ?? this.isEmoji,
      style: style ?? this.style,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
