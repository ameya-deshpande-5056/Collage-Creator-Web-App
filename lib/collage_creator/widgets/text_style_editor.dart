import '../collage_creator.dart';

class TextStyleEditor extends StatefulWidget {
  final TextStyle initialStyle;
  final String initialFont;
  final void Function(TextStyle style, String font) onStyleChanged;

  const TextStyleEditor({
    super.key,
    required this.initialStyle,
    required this.initialFont,
    required this.onStyleChanged,
  });

  @override
  State<TextStyleEditor> createState() => _TextStyleEditorState();
}

class _TextStyleEditorState extends State<TextStyleEditor> {
  late TextStyle _style;
  late String _fontFamily;
  Color get _color => _style.color ?? Colors.black;

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _fontFamily = widget.initialFont;
  }

  void _updateStyle(TextStyle newStyle) {
    setState(() => _style = newStyle);
    widget.onStyleChanged(_style, _fontFamily);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Font Size Dropdown
        dynamicRowColumnShifter(
          context,
          children: [
            Row(
              children: [
                const Text('Font Size: '),
                DropdownButton<double>(
                  value: _style.fontSize ?? 12.0,
                  items: fontSizeOptions.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size.toString()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _updateStyle(_style.copyWith(fontSize: val));
                    }
                  },
                ),
              ],
            ),
            dynamicSizedBox(context, widthOrHeight: 15),
            // Font Style Chips
            Wrap(
              spacing: 7.5,
              children: [
                FilterChip(
                  label: const Text("B", style: TextStyle(fontWeight: FontWeight.bold)),
                  selected: _style.fontWeight == FontWeight.bold,
                  onSelected: (val) =>
                      _updateStyle(_style.copyWith(fontWeight: val ? FontWeight.bold : FontWeight.normal)),
                ),
                FilterChip(
                  label: const Text("I", style: TextStyle(fontStyle: FontStyle.italic)),
                  selected: _style.fontStyle == FontStyle.italic,
                  onSelected: (val) =>
                      _updateStyle(_style.copyWith(fontStyle: val ? FontStyle.italic : FontStyle.normal)),
                ),
                FilterChip(
                  label: const Text("U", style: TextStyle(decoration: TextDecoration.underline)),
                  selected: _style.decoration == TextDecoration.underline,
                  onSelected: (val) =>
                      _updateStyle(_style.copyWith(decoration: val ? TextDecoration.underline : TextDecoration.none)),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 10),
        // Font Family Dropdown
        dynamicRowColumnShifter(
          context,
          children: [
            Row(
              children: [
                const Text("Font: "),
                DropdownButton<String>(
                  value: _fontFamily,
                  items: fonts.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font, style: TextStyle(fontFamily: font)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _fontFamily = val);
                      widget.onStyleChanged(_style, _fontFamily);
                    }
                  },
                ),
              ],
            ),
            dynamicSizedBox(context, widthOrHeight: 15),
            // Color Picker
            Row(
              children: [
                const Text("Color: "),
                GestureDetector(
                  onTap: () async {
                    final newColor = await showDialog<Color>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Pick a color"),
                        content: BlockPicker(
                          pickerColor: _color,
                          onColorChanged: (color) => Navigator.pop(context, color),
                        ),
                      ),
                    );
                    if (newColor != null) {
                      _updateStyle(_style.copyWith(color: newColor));
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
