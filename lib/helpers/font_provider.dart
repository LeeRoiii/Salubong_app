import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  String _selectedFont = 'Roboto';
  bool _isDarkMode = false;
  bool _showDateOnLeft = false;  // New property to manage date alignment
  bool _showLocation = true;      // New property to manage location visibility
  double _fontSize = 16.0;        // New property for font size

  // Store font options in a list
  final List<String> _fontOptions = [
    'Roboto',
    'Arial',
    'Courier New',
    'Times New Roman',
    'Georgia',
  ];

  List<String> get fontOptions => _fontOptions;
  String get selectedFont => _selectedFont;
  bool get isDarkMode => _isDarkMode;
  bool get showDateOnLeft => _showDateOnLeft;
  bool get showLocation => _showLocation;
  double get fontSize => _fontSize;

  FontProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _showDateOnLeft = prefs.getBool('showDateOnLeft') ?? false; // Load date alignment preference
    _showLocation = prefs.getBool('showLocation') ?? true;       // Load location visibility preference
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;             // Load font size preference
    notifyListeners();
  }

  Future<void> setFont(String font) async {
    _selectedFont = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
    notifyListeners();
  }

  Future<void> setShowDateOnLeft(bool value) async {
    _showDateOnLeft = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDateOnLeft', value);
    notifyListeners();
  }

  Future<void> setShowLocation(bool value) async {
    _showLocation = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showLocation', value);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  // Add a method to add new fonts
  void addFont(String font) {
    if (!_fontOptions.contains(font)) {
      _fontOptions.add(font);
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }
}
