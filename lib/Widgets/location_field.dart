// location_field.dart
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Ensure to import latlong2 for LatLng

class LocationField extends StatelessWidget {
  final TextEditingController locationController;

  const LocationField({required this.locationController, required void Function() onLocationSelected});

  Future<void> _pickLocation(BuildContext context) async {
    LatLng? selectedLocation = await showDialog<LatLng?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a Location'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                onTap: (tapPosition, point) {
                  Navigator.of(context).pop(point); // Return selected point
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                // Add additional layers if needed
              ],
            ),
          ),
        );
      },
    );

    // Update the controller with the selected location if not null
    if (selectedLocation != null) {
      locationController.text = "${selectedLocation.latitude}, ${selectedLocation.longitude}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LOCATION',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        CupertinoTextField(
          controller: locationController,
          placeholder: 'Optional Enter location...',
          padding: const EdgeInsets.all(16.0),
          style: const TextStyle(fontSize: 18),
          suffix: GestureDetector(
            onTap: () => _pickLocation(context),
            child: const Icon(
              CupertinoIcons.location_circle,
              size: 28,
              color: CupertinoColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
