import 'package:flutter/cupertino.dart';

class EventSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionSelected;

  const EventSuggestions({super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUGGESTIONS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CupertinoButton(
                  color: CupertinoColors.black,
                  child: Text(suggestion),
                  onPressed: () => onSuggestionSelected(suggestion),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

