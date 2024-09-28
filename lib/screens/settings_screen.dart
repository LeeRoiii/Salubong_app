import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../helpers/font_provider.dart'; // Import your FontProvider

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPickerVisible = false; // Variable to track visibility

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);

    return CupertinoPageScaffold(
      child: SingleChildScrollView( // Enable scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title at the top of the Settings screen
            const Text(
              'Settings',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text('Font Customization', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPickerVisible = !_isPickerVisible; // Toggle visibility
                });
              },
              child: Text(
                _isPickerVisible ? 'Hide Font Options' : 'Show Font Options',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_isPickerVisible) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    fontProvider.setFont(fontProvider.fontOptions[index]);
                  },
                  children: fontProvider.fontOptions
                      .map((String font) => Center(child: Text(font)))
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 40),
            const Text('Appearance Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode', style: TextStyle(fontSize: 18)),
                CupertinoSwitch(
                  value: fontProvider.isDarkMode,
                  onChanged: (value) {
                    fontProvider.toggleDarkMode(value);
                    setState(() {}); // Refresh the UI
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Notification Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enable Notifications', style: TextStyle(fontSize: 18)),
                CupertinoSwitch(
                  value: true, // Replace with actual state from your provider
                  onChanged: (value) {
                    // Handle notification toggle logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Language Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Handle language selection here
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Select Language',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}