import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  String _selectedFont = 'Roboto';  // Default font
  bool _isDarkMode = false;          // Default theme mode

  // List of available font options
  List<String> get fontOptions => ['Roboto', 'Arial', 'Courier New', 'Times New Roman', 'Georgia'];

  String get selectedFont => _selectedFont;
  bool get isDarkMode => _isDarkMode;

  FontProvider() {
    _loadPreferences(); // Load preferences when provider is initialized
  }

  // Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';  // Set selected font
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;          // Set dark mode status
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Set the selected font and save to SharedPreferences
  Future<void> setFont(String font) async {
    _selectedFont = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font); // Save the font to SharedPreferences
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Toggle dark mode and save preference
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value); // Save the dark mode status
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
