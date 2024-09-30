import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Widgets/event_card.dart';
import '../helpers/database_helper.dart';
import '../helpers/font_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<Map<String, dynamic>>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events when the screen initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshEvents();
  }

  // Fetch events from the database
  void _loadEvents() {
    setState(() {
      _futureEvents = dbHelper.queryAllRows();
    });
  }

  // Refresh the events when pulled down
  Future<void> _refreshEvents() async {
    _loadEvents(); // Reload events
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('MMMM d, yyyy').format(DateTime.now());
    final fontProvider = Provider.of<FontProvider>(context);
    final selectedFont = fontProvider.selectedFont;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container( // Container to set background color
          color: CupertinoColors.white, // Set background color to white
          child: DefaultTextStyle(
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: CupertinoColors.black, // Set a default color
              fontSize: 16, // Set a default font size
            ),
            child: RefreshIndicator(
              onRefresh: _refreshEvents, // Set up the refresh function
              child: CustomScrollView(
                slivers: [
                  _buildHeader(dateString),
                  _buildEventList(selectedFont, fontProvider), // Pass fontProvider here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build the header for the Events screen
  Widget _buildHeader(String dateString) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                color: CupertinoColors.systemGrey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Upcoming Events',
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the list of events
  Widget _buildEventList(String selectedFont, FontProvider fontProvider) {
    // Fetch specific font sizes from FontProvider
    final titleFontSize = fontProvider.titleFontSize;
    final dateFontSize = fontProvider.dateFontSize;
    final locationFontSize = fontProvider.locationFontSize;
    final daysUntilFontSize = fontProvider.daysUntilFontSize;
    final cardBorderRadius = fontProvider.cardBorderRadius; // Get card border radius

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 10.0,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoEventsWidget();
        } else {
          final events = snapshot.data!;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  selectedFont: selectedFont,
                  titleFontSize: titleFontSize,         // Pass title font size
                  dateFontSize: dateFontSize,           // Pass date font size
                  locationFontSize: locationFontSize,   // Pass location font size
                  daysUntilFontSize: daysUntilFontSize, // Pass days until font size
                  cardBorderRadius: cardBorderRadius,   // Pass card border radius
                );
              },
              childCount: events.length,
            ),
          );
        }
      },
    );
  }

  // Build the error widget
  Widget _buildErrorWidget(Object? error) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error fetching events: $error',
          style: const TextStyle(color: CupertinoColors.systemRed),
        ),
      ),
    );
  }

  // Build the no events widget
  Widget _buildNoEventsWidget() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.calendar_badge_plus,
              size: 100,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(height: 24),
            Text(
              'No events yet.',
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Start organizing your life by adding your first event! Let's get started!",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 16,
                color: CupertinoColors.systemGrey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
