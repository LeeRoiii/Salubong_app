import 'package:flutter/cupertino.dart';   // Cupertino widgets
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource, XFile;

import '../Widgets/background_options.dart';
import '../Widgets/event_suggestion.dart';
import '../helpers/database_helper.dart';
import '../Widgets/location_field.dart';
import '../Widgets/date_picker.dart';
import '../Widgets/event_preview.dart';
import '../Widgets/input_fields.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

final List<String> _eventSuggestions = [
  'My Birthday 🎉',
  'Wedding 💍',
  'Graduation 🎓',
  'Anniversary ❤️',
  'Christmas 🎄',
  'New Year 🎆',
  'Baby Shower 👶',
  'Bridal Shower 👰',
  'Engagement 💍',
  'Concert 🎤',
  'Family Reunion 👨‍👩‍👧‍👦',
  'Charity Event 💖',
  'Sports Game 🏀',
  'Holiday Party 🎉',
  'Business Launch 🚀',
  'Date Night 💕',
  'Job Interview 💼',
  'Doctor’s Appointment 🏥',
  'Book Club 📚',
  'Movie Night 🎬',
  'Gaming Tournament 🎮',
  'Back to School 🎒',
  'Shopping Day 🛍️',
  'Art Exhibit 🎨',
  'Music Festival 🎶',
  'Marathon 🏃‍♂️',
  'Tech Expo 💻',
];

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _backgroundImageUrl;
  Color _color = CupertinoColors.black; // Set black as the default color
  Gradient? _backgroundGradient;

  final dbHelper = DatabaseHelper.instance;

  // Use ValueNotifier to hold state
  final ValueNotifier<String> _eventNameNotifier = ValueNotifier('');
  final ValueNotifier<String> _locationNotifier = ValueNotifier('');

  final ImagePicker _picker = ImagePicker();

  // Update the image selection and notify listeners
  Future<void> _selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _backgroundImageUrl = pickedFile.path;
        _backgroundGradient = null;
      });
    }
  }

  // Update color and notify listeners
  void _setColorAndGradient(Color color) {
    setState(() {
      _color = color;
      _backgroundImageUrl = null;
      _backgroundGradient = LinearGradient(
        colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
      );
    });
  }

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          DatePickerWidget(
            initialDate: _selectedDate,
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
    );
  }

  // Save event to database with validation and success message
  void _saveEvent() async {
    if (_eventNameController.text.isEmpty) {
      _showAlert('Please fill in the event name.');
      return;
    }

    // Save the event, with optional location
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _eventNameController.text,
      DatabaseHelper.columnDate: _selectedDate.toIso8601String(),
      DatabaseHelper.columnReminder: _reminderController.text,
      DatabaseHelper.columnLocation: _locationController.text.isNotEmpty
          ? _locationController.text
          : null,
      DatabaseHelper.columnBackgroundImage: _backgroundImageUrl,
      DatabaseHelper.columnColor: _color.value,
    };

    final id = await dbHelper.insert(row);
    if (id > 0) {
      _showAlert('Event added successfully!', isSuccess: true);
    } else {
      _showAlert('Failed to add event. Please try again.');
    }
  }

  void _clearForm() {
    setState(() {
      _eventNameController.clear();
      _reminderController.clear();
      _locationController.clear();
      _selectedDate = DateTime.now();
      _backgroundImageUrl = null;
      _backgroundGradient = null;

      // Clear the notifiers
      _eventNameNotifier.value = '';
      _locationNotifier.value = '';
    });
  }

  void _showAlert(String message, {bool isSuccess = false}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoTheme(
              data: CupertinoThemeData(
                primaryColor: CupertinoColors
                    .black, // Set button color to black
              ),
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  if (isSuccess) {
                    _clearForm(); // Clear the form on success
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Container(
            color: CupertinoColors.white, // Set background color to white
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: _eventNameNotifier,
                    builder: (context, eventName, child) {
                      return EventPreviewWidget(
                        eventNameController: _eventNameController,
                        selectedDate: _selectedDate,
                        backgroundImageUrl: _backgroundImageUrl,
                        backgroundGradient: _backgroundGradient,
                        color: _color,
                        location: _locationController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  EventTitleField(eventNameController: _eventNameController),
                  const SizedBox(height: 10),
                  EventSuggestions(
                    suggestions: _eventSuggestions,
                    onSuggestionSelected: (suggestion) {
                      _eventNameController.text = suggestion;
                      _eventNameNotifier.value =
                          suggestion; // Update the notifier
                    },
                  ),
                  const SizedBox(height: 20),
                  DateField(
                    selectedDate: _selectedDate,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),
                  ReminderField(reminderController: _reminderController),
                  const SizedBox(height: 20),
                  LocationField(
                    locationController: _locationController,
                    onLocationSelected: () {}, // Optionally handle location changes
                  ),
                  const SizedBox(height: 20),
                  BackgroundOptions(
                    onImageSelected: _selectImageFromGallery,
                    onColorSelected: _setColorAndGradient,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    height: 50, // Set the desired height
                    child: Center(
                      child: CupertinoButton(
                        color: CupertinoColors.black,
                        // Set the button color to black
                        borderRadius: BorderRadius.circular(8.0),
                        // Optional: Add rounded corners
                        onPressed: _saveEvent,
                        child: const Text(
                          'Done',
                          style: TextStyle(color: CupertinoColors
                              .white), // Set text color to white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
