import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorPickerLogic {
  // List of available colors
  final List<Map<String, dynamic>> colors = [
    // Normal Colors
    {'color': CupertinoColors.systemBlue, 'name': 'Blue'},
    {'color': CupertinoColors.systemGreen, 'name': 'Green'},
    {'color': CupertinoColors.systemRed, 'name': 'Red'},
    {'color': CupertinoColors.systemOrange, 'name': 'Orange'},
    {'color': CupertinoColors.systemPink, 'name': 'Pink'},
    {'color': CupertinoColors.systemYellow, 'name': 'Yellow'},
    {'color': CupertinoColors.systemTeal, 'name': 'Teal'},
    {'color': Colors.purple, 'name': 'Purple'},
    {'color': Colors.brown, 'name': 'Brown'},
    {'color': Colors.grey, 'name': 'Grey'},
    {'color': Colors.cyan, 'name': 'Cyan'},
    {'color': Colors.indigo, 'name': 'Indigo'},
    {'color': Colors.lime, 'name': 'Lime'},
    {'color': Colors.amber, 'name': 'Amber'},
    {'color': Colors.deepPurple, 'name': 'Deep Purple'},
    {'color': Colors.deepOrange, 'name': 'Deep Orange'},
    {'color': Colors.black, 'name': 'Black'},
    {'color': Colors.white, 'name': 'White'},

    // Accent Colors
    {'color': Colors.greenAccent, 'name': 'Green Accent'},
    {'color': Colors.blueGrey, 'name': 'Blue Grey'},
    {'color': Colors.yellowAccent, 'name': 'Yellow Accent'},
    {'color': Colors.orangeAccent, 'name': 'Orange Accent'},
    {'color': Colors.pinkAccent, 'name': 'Pink Accent'},
    {'color': Colors.redAccent, 'name': 'Red Accent'},
    {'color': Colors.lightBlueAccent, 'name': 'Light Blue Accent'},
    {'color': Colors.purpleAccent, 'name': 'Purple Accent'},
    {'color': Colors.amberAccent, 'name': 'Amber Accent'},

    // Light Colors (Using lighter shades instead of non-existing colors)
    {'color': Colors.lightBlue[100]!, 'name': 'Light Blue'},
    {'color': Colors.lightGreen[100]!, 'name': 'Light Green'},
    {'color': Colors.pink[100]!, 'name': 'Light Pink'},
    {'color': Colors.yellow[100]!, 'name': 'Light Yellow'},
    {'color': Colors.orange[100]!, 'name': 'Light Orange'},
    {'color': Colors.purple[100]!, 'name': 'Light Purple'},
    {'color': Colors.cyan[100]!, 'name': 'Light Cyan'},
    {'color': Colors.indigo[100]!, 'name': 'Light Indigo'},
    {'color': Colors.brown[100]!, 'name': 'Light Brown'},

    // Deep Colors
    {'color': Colors.blueAccent, 'name': 'Blue Accent'},
    {'color': Colors.deepPurpleAccent, 'name': 'Deep Purple Accent'},
    {'color': Colors.tealAccent, 'name': 'Teal Accent'},
    {'color': Colors.deepOrangeAccent, 'name': 'Deep Orange Accent'},
    {'color': Colors.redAccent, 'name': 'Deep Red'},
    {'color': Colors.greenAccent, 'name': 'Deep Green'},

    // Pastel Colors (Using existing pastel colors)
    {'color': Colors.pink[200]!, 'name': 'Pastel Pink'},
    {'color': Colors.blue[200]!, 'name': 'Pastel Blue'},
    {'color': Colors.green[200]!, 'name': 'Pastel Green'},
    {'color': Colors.yellow[200]!, 'name': 'Pastel Yellow'},
    {'color': Colors.orange[200]!, 'name': 'Pastel Orange'},
    {'color': Colors.purple[200]!, 'name': 'Pastel Purple'},
    {'color': Colors.teal[200]!, 'name': 'Pastel Teal'},

    // Neon Colors
    {'color': Colors.pinkAccent[200]!, 'name': 'Neon Pink'},
    {'color': Colors.greenAccent[200]!, 'name': 'Neon Green'},
    {'color': Colors.yellowAccent[200]!, 'name': 'Neon Yellow'},
    {'color': Colors.blueAccent[200]!, 'name': 'Neon Blue'},
    {'color': Colors.orangeAccent[200]!, 'name': 'Neon Orange'},
    {'color': Colors.redAccent[200]!, 'name': 'Neon Red'},
    {'color': Colors.purpleAccent[200]!, 'name': 'Neon Purple'},

    // Additional Colors
    {'color': Colors.cyanAccent, 'name': 'Cyan Accent'},


    // Extra Colors for Variety
    {'color': Colors.yellow[300]!, 'name': 'Bright Yellow'},
    {'color': Colors.red[300]!, 'name': 'Bright Red'},
  ];

  // Method to filter and sort colors
  List<Map<String, dynamic>> filterColors(String searchTerm) {
    List<Map<String, dynamic>> filteredColors;
    if (searchTerm.isEmpty) {
      filteredColors = List.from(colors); // Return all colors if no search term
    } else {
      filteredColors = colors.where((color) =>
          color['name'].toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }

    // Sort the colors with custom logic
    filteredColors.sort((a, b) {
      // Define the sorting order based on the type of color
      int orderA = _colorSortOrder(a['name']);
      int orderB = _colorSortOrder(b['name']);

      // Compare based on the defined order
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      } else {
        return a['name'].compareTo(b['name']); // Alphabetical order if same type
      }
    });

    return filteredColors;
  }

  // Custom order definition for sorting
  int _colorSortOrder(String colorName) {
    if (colorName.contains("Light")) {
      return 4; // Light colors come last
    } else if (colorName.contains("Deep")) {
      return 2; // Deep colors come second
    } else if (colorName.contains("Accent")) {
      return 3; // Accent colors come in the middle
    } else if (colorName.contains("Pastel")) {
      return 1; // Pastel colors come before deep and accent
    }
    return 0; // Normal colors come first
  }
}
