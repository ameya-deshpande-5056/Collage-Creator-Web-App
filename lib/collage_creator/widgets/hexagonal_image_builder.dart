import '../collage_creator.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Create a hexagon by calculating 6 points
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i + (pi / 6); // Start at 30 degrees
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget buildHexagonalImage(
  Uint8List img,
  double size,
) {
  return ClipPath(
    clipper: HexagonClipper(),
    child: SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: HexagonClipper(),
        child: Image.memory(img, fit: BoxFit.fill),
      ),
    ),
  );
}