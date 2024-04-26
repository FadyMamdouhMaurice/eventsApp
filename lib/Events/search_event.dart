import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/shared/firebase_functions.dart';

FirebaseFunctions firebaseFunctions = FirebaseFunctions();
final userId = firebaseFunctions.getUserId();
final interestedProvider = StateProvider.autoDispose<bool>((ref) => false);

class EventSearchDelegate extends SearchDelegate<String> {
  final List<EventModel> events;
  final List<EventModel> interestedEvents; // User's interested events
  final List<EventModel> goingEvents; // User's going events

  EventSearchDelegate(this.events, this.interestedEvents, this.goingEvents);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<EventModel> searchResults = events
        .where((event) =>
            event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.details.toLowerCase().contains(query.toLowerCase()) ||
            event.date.toString().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        //final event = searchResults[index];
        // Build UI for displaying each search result
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<EventModel> suggestionResults = events
        .where((event) =>
            event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.details.toLowerCase().contains(query.toLowerCase()) ||
            event.date.toString().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionResults.length,
      itemBuilder: (context, index) {
        final event = suggestionResults[index];
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return EventCard(
              event: event,
              interestedEvents: interestedEvents,
              toggleInterest: (event, isInterested) async {
                if (userId != null) {
                  await firebaseFunctions.updateUserInterest(
                      userId!, event.id, isInterested);
                  // Refresh UI if necessary
                  //ref.read(interestedProvider.notifier).state = isInterested;
                }
              },
            );
          },
        );
      },
    );
  }
}

class EventCard extends ConsumerWidget {
  final EventModel event;
  final List<EventModel> interestedEvents;
  final Function(EventModel, bool) toggleInterest;

  const EventCard({super.key,
    required this.event,
    required this.interestedEvents,
    required this.toggleInterest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the interested state using Riverpod
    final bool interestedState = ref.watch(interestedProvider);

    final bool isInterested = interestedEvents.any((e) => e.id == event.id);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.details),
            Text('Location: ${event.location}'),
            Text('Date: ${event.date.toString()}'),
            Text(
                'Description: ${event.description ?? "No description provided"}'),
            Row(
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () async {
                      // Toggle interest
                      toggleInterest(event, !isInterested);
                      // Update state
                    },
                    icon: Icon(
                      isInterested ? Icons.star : Icons.star_border,
                      color: isInterested ? Colors.yellow : null,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
