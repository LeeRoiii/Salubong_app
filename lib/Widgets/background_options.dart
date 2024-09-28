import 'package:flutter/cupertino.dart';

import 'color_picker.dart';

class BackgroundOptions extends StatefulWidget {
  final VoidCallback onImageSelected;
  final Function(Color) onColorSelected;

  const BackgroundOptions({super.key,
    required this.onImageSelected,
    required this.onColorSelected,
  });

  @override
  _BackgroundOptionsState createState() => _BackgroundOptionsState();
}

class _BackgroundOptionsState extends State<BackgroundOptions> {
  final ColorPickerLogic colorPickerLogic = ColorPickerLogic();
  List<Map<String, dynamic>> _filteredColors = [];
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _filteredColors = colorPickerLogic.colors;
  }

  void _selectColor(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Color For Event Card'),
        message: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    autofocus: true,
                    placeholder: 'Search Color by name..',
                    onChanged: (value) {
                      setState(() {
                        _filteredColors = colorPickerLogic.filterColors(value);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: _filteredColors.isNotEmpty
                      ? ListView.builder(
                    itemCount: _filteredColors.length,
                    itemBuilder: (context, index) {
                      final color = _filteredColors[index];
                      return _colorAction(
                          color['color'], color['name'], context);
                    },
                  )
                      : const Center(
                    child: Text('No colors found'),
                  ),
                ),
              ],
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  CupertinoActionSheetAction _colorAction(
      Color color, String label, BuildContext context) {
    return CupertinoActionSheetAction(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.circle_fill, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onPressed: () {
        widget.onColorSelected(color);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BACKGROUND',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(
              onPressed: widget.onImageSelected,
              child: const Column(
                children: [
                  Icon(CupertinoIcons.photo, size: 40),
                  Text('Gallery'),
                ],
              ),
            ),
            CupertinoButton(
              onPressed: () => _selectColor(context),
              child: const Column(
                children: [
                  Icon(CupertinoIcons.color_filter, size: 40),
                  Text('Color'),
                ],
              ),
            ),
            CupertinoButton(
              onPressed: () {
                // Future functionality for selecting from library
              },
              child: const Column(
                children: [
                  Icon(CupertinoIcons.folder, size: 40),
                  Text('Library'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

