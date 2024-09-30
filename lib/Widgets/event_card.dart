import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/database_helper.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final String selectedFont;
  final double titleFontSize; // For title font size
  final double dateFontSize; // For date font size
  final double locationFontSize; // For location font size
  final double daysUntilFontSize; // For days until font size
  final double cardBorderRadius; // For card border radius

  const EventCard({
    Key? key,
    required this.event,
    required this.selectedFont,
    required this.titleFontSize,
    required this.dateFontSize,
    required this.locationFontSize,
    required this.daysUntilFontSize,
    required this.cardBorderRadius, // Add card border radius to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String eventName = event[DatabaseHelper.columnName] ?? 'Event';
    final DateTime eventDate = DateTime.parse(event[DatabaseHelper.columnDate]);
    final String? location = event[DatabaseHelper.columnLocation];
    final String? backgroundImageUrl = event[DatabaseHelper.columnBackgroundImage];
    final int? colorValue = event[DatabaseHelper.columnColor];
    final Color eventColor = colorValue != null
        ? Color(colorValue)
        : CupertinoColors.systemGrey;
    final int daysUntil = eventDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        // Add navigation or other actions on tap if needed
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius), // Use the new card border radius
          boxShadow: [
            BoxShadow(
              color: eventColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardBorderRadius), // Use the new card border radius
          child: Stack(
            children: [
              // Use CachedNetworkImage for better image handling
              _buildBackgroundImage(backgroundImageUrl, eventColor),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildEventDetails(eventName, eventDate, daysUntil, location),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String? backgroundImageUrl, Color eventColor) {
    if (backgroundImageUrl != null && File(backgroundImageUrl).existsSync()) {
      return Image.file(
        File(backgroundImageUrl),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (backgroundImageUrl != null) {
      return CachedNetworkImage(
        imageUrl: backgroundImageUrl,
        placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: eventColor.withOpacity(0.5), // Fallback color
          child: Center(child: Icon(Icons.error, color: CupertinoColors.white)),
        ),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [eventColor, eventColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }
  }

  Widget _buildEventDetails(String eventName, DateTime eventDate, int daysUntil, String? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventName,
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: titleFontSize, // Use title font size
            fontWeight: FontWeight.bold,
            fontFamily: selectedFont,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('MMMM d, yyyy').format(eventDate),
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: dateFontSize, // Use date font size
            decoration: TextDecoration.none, // Remove underline
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$daysUntil ${daysUntil == 1 ? 'Day' : 'Days'} Until',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: daysUntilFontSize, // Use days until font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (location != null && location.isNotEmpty)
              Expanded(
                child: Text(
                  location,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: locationFontSize, // Use location font size
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
