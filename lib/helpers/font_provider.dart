import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  String _selectedFont = 'Arial';

  // Font sizes for different text elements
  double _titleFontSize = 30.0;
  double _dateFontSize = 16.0;
  double _locationFontSize = 14.0;
  double _daysUntilFontSize = 12.0;

  // Card appearance
  double _cardBorderRadius = 0.0; // Default border radius

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

  // Getter methods for font sizes
  double get titleFontSize => _titleFontSize;
  double get dateFontSize => _dateFontSize;
  double get locationFontSize => _locationFontSize;
  double get daysUntilFontSize => _daysUntilFontSize;

  // Getter for card border radius
  double get cardBorderRadius => _cardBorderRadius;

  FontProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    _titleFontSize = prefs.getDouble('titleFontSize') ?? 30.0;
    _dateFontSize = prefs.getDouble('dateFontSize') ?? 16.0;
    _locationFontSize = prefs.getDouble('locationFontSize') ?? 14.0;
    _daysUntilFontSize = prefs.getDouble('daysUntilFontSize') ?? 12.0;

    // Load card border radius preference
    _cardBorderRadius = prefs.getDouble('cardBorderRadius') ?? 0.0;
    notifyListeners();
  }

  Future<void> setFont(String font) async {
    if (font != _selectedFont) {
      _selectedFont = font;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedFont', font);
      notifyListeners();
    }
  }

  Future<void> setTitleFontSize(double size) async {
    if (size != _titleFontSize) {
      _titleFontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('titleFontSize', size);
      notifyListeners();
    }
  }

  Future<void> setDateFontSize(double size) async {
    if (size != _dateFontSize) {
      _dateFontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('dateFontSize', size);
      notifyListeners();
    }
  }

  Future<void> setLocationFontSize(double size) async {
    if (size != _locationFontSize) {
      _locationFontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('locationFontSize', size);
      notifyListeners();
    }
  }

  Future<void> setDaysUntilFontSize(double size) async {
    if (size != _daysUntilFontSize) {
      _daysUntilFontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('daysUntilFontSize', size);
      notifyListeners();
    }
  }

  // Method to set card border radius
  Future<void> setCardBorderRadius(double radius) async {
    if (radius != _cardBorderRadius) {
      _cardBorderRadius = radius;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('cardBorderRadius', radius);
      notifyListeners();
    }
  }
}
