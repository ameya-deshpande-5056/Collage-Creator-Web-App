import '../collage_creator.dart';

class TextEmojiPanel extends StatefulWidget {
  final void Function(String text, Color color, TextStyle style, String font)
  onTextAdd;
  final void Function(String emoji) onEmojiAdd;

  const TextEmojiPanel({
    super.key,
    required this.onTextAdd,
    required this.onEmojiAdd,
  });

  @override
  State<TextEmojiPanel> createState() => _TextEmojiPanelState();
}

class _TextEmojiPanelState extends State<TextEmojiPanel> {
  final TextEditingController _textController = TextEditingController();
  bool _showEmojiPicker = false;
  TextStyle _currentStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  );
  String _selectedFont = fonts[0];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelText: 'Enter Text',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _textController.clear(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextStyleEditor(
            initialStyle: _currentStyle,
            initialFont: _selectedFont,
            onStyleChanged: (style, font) {
              setState(() {
                _currentStyle = style;
                _selectedFont = font;
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isNotEmpty) {
                    widget.onTextAdd(
                      text,
                      _currentStyle.color ?? Colors.black,
                      _currentStyle,
                      _selectedFont,
                    );
                    debugPrint("On pressing ElevatedButton: $_selectedFont");
                    _textController.clear();
                  }
                },
                child: const Text("Add Text"),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  setState(() => _showEmojiPicker = !_showEmojiPicker);
                },
                child: const Text("Pick Emoji"),
              ),
            ],
          ),
          if (_showEmojiPicker)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).width * 0.26,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    widget.onEmojiAdd(emoji.emoji);
                    setState(() => _showEmojiPicker = false);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
