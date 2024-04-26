import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:symstax_events/Events/view_event_location.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/shared/map_functions.dart';

FirebaseFunctions firebaseFunctions = FirebaseFunctions();
final userId = firebaseFunctions.getUserId();
//final interestedProvider = StateProvider.autoDispose<bool>((ref) => false);

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
                }
              }, goingEvents: goingEvents,
              toggleGoing: (event, isGoing) async {
                if (userId != null) {
                  await firebaseFunctions.updateUserGoing(
                      userId!, event.id, isGoing);
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
  final List<EventModel> goingEvents;
  final Function(EventModel, bool) toggleGoing;

  const EventCard({
    Key? key,
    required this.event,
    required this.interestedEvents,
    required this.toggleInterest,
    required this.goingEvents,
    required this.toggleGoing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final bool isInterested =
    ref.watch(isSearchedEventInterestedProvider(event.id));
    final bool isGoing = ref.watch(isSearchedEventGoingProvider(event.id));

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 0.04 * screenWidth, vertical: 0.02 * screenHeight),
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: Text(event.title)),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Call share function here
                shareEvent(event);
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.details),
            Row(
              children: [
                Expanded(child: Text('Location: ${event.location}')),
                IconButton(
                  icon:Icon(Icons.location_on, color: Colors.red) , onPressed: () {
                  LatLng mapLocation = parseLocation(event.location);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewEventMaP(eventLocation: mapLocation),
                    ),
                  );
                },
                ),
              ],
            ),
            Text('Date: ${event.date.toString()}'),
            Text(
                'Description: ${event.description ?? "No description provided"}'),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(screenWidth * 0.004),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            toggleInterest(event, !isInterested);
                          },
                          icon: Icon(
                            isInterested ? Icons.star : Icons.star_border,
                            color: isInterested ? Colors.yellow : null,
                          ),
                        ),
                        Text(isInterested ? 'Not Interested' : 'Interested'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02,),
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(screenWidth * 0.004),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isGoing ? Icons.check_circle : Icons.check_circle_outline,
                            color: isGoing ? Colors.green : null,
                          ),
                          onPressed: () async {
                            toggleGoing(event, !isGoing);
                          },
                        ),
                        Text(isGoing ? 'Not Going' : 'Going'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}