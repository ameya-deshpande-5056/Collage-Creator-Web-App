import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onPickImages;

  const EmptyState({super.key, required this.onPickImages});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          getContentHeaderText(noImagesSelectedTxt),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPickImages,
            child: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.photo_library), getContentHeaderText(pickImagesTxt)],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
