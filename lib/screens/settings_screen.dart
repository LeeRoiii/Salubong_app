import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/font_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPickerVisible = false;
  bool _isCardOptionsVisible = false; // For card appearance options
  int _selectedDaysUntilStyle = 0; // Index for Days Until style selection

  // Styles for Days Until options
  final List<TextStyle> _daysUntilStyles = [
    TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
    TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.normal),
    TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.w300),
  ];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Customization',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Font Options Toggle
                _buildToggleOption(
                  title: _isPickerVisible ? 'Hide Font Options' : 'Show Font Options',
                  onPressed: () {
                    setState(() {
                      _isPickerVisible = !_isPickerVisible;
                    });
                  },
                ),
                if (_isPickerVisible) ...[
                  const SizedBox(height: 16),
                  _buildFontPicker(fontProvider),
                  const SizedBox(height: 24),
                  _buildFontSizeSetting('Title Font Size', fontProvider.titleFontSize, fontProvider.setTitleFontSize),
                  _buildFontSizeSetting('Date Font Size', fontProvider.dateFontSize, fontProvider.setDateFontSize),
                  _buildFontSizeSetting('Location Font Size', fontProvider.locationFontSize, fontProvider.setLocationFontSize),
                  _buildFontSizeSetting('Days Until Font Size', fontProvider.daysUntilFontSize, fontProvider.setDaysUntilFontSize),
                ],

                // Card Appearance Options Toggle
                _buildToggleOption(
                  title: _isCardOptionsVisible ? 'Hide Card Appearance Options' : 'Show Card Appearance Options',
                  onPressed: () {
                    setState(() {
                      _isCardOptionsVisible = !_isCardOptionsVisible;
                    });
                  },
                ),
                if (_isCardOptionsVisible) ...[
                  const SizedBox(height: 16),
                  _buildBorderRadiusSetting(fontProvider.cardBorderRadius, fontProvider.setCardBorderRadius),
                  const SizedBox(height: 24),
                  const Text(
                    'Days Until Style',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDaysUntilStyleOptions(), // Add Days Until Style options here
                ],

                const Divider(height: 1, color: CupertinoColors.systemGrey4),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build font picker
  Widget _buildFontPicker(FontProvider fontProvider) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) {
          fontProvider.setFont(fontProvider.fontOptions[index]);
        },
        children: fontProvider.fontOptions
            .map((String font) => Center(
          child: Text(
            font,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ))
            .toList(),
      ),
    );
  }

  // Helper method to build font size rows
  Widget _buildFontSizeSetting(String title, double fontSize, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
        _buildFontSizeRow(fontSize, onChanged),
      ],
    );
  }

  // Helper method to build border radius row
  Widget _buildBorderRadiusSetting(double borderRadius, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Border Radius',
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        _buildBorderRadiusRow(borderRadius, onChanged),
      ],
    );
  }

  // Helper method to build font size rows
  Widget _buildFontSizeRow(double fontSize, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 80,
          child: Text(
            fontSize.toStringAsFixed(1),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: CupertinoSlider(
            value: fontSize,
            min: 10.0,
            max: 50.0,
            divisions: 32,
            activeColor: Colors.black,
            thumbColor: Colors.black,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Helper method to build border radius row
  Widget _buildBorderRadiusRow(double borderRadius, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 80,
          child: Text(
            borderRadius.toStringAsFixed(1), // Display border radius
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: CupertinoSlider(
            value: borderRadius,
            min: 0.0,
            max: 50.0, // Adjust max value as needed
            divisions: 50,
            activeColor: Colors.black,
            thumbColor: Colors.black,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Helper method to build toggle options
  Widget _buildToggleOption({required String title, required VoidCallback onPressed}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Icon(
            title.startsWith('Hide') ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
            size: 22,
            color: CupertinoColors.black,
          ),
        ],
      ),
    );
  }

  // Helper method to build Days Until style options
  Widget _buildDaysUntilStyleOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (index) {
        return Row(
          children: [
            CupertinoRadio<int>(
              value: index,
              groupValue: _selectedDaysUntilStyle,
              onChanged: (value) {
                setState(() {
                  _selectedDaysUntilStyle = value ?? 0;
                  // Here you can also call the provider to save the selected style
                  // For example: fontProvider.setDaysUntilStyle(value);
                });
              },
            ),
            Text(
              'Style ${index + 1}',
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
            // Display an example of the style
            SizedBox(width: 10),
            Text(
              'Example: 5 days',
              style: _daysUntilStyles[index],
            ),
          ],
        );
      }),
    );
  }
}
