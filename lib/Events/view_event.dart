import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:symstax_events/Events/search_event.dart';
import 'package:symstax_events/Events/view_event_location.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/shared/map_functions.dart';

FirebaseFunctions firebaseFunctions = FirebaseFunctions();

class ViewEventScreen extends ConsumerWidget {
  const ViewEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double screenWidth = MediaQuery.of(context).size.width;

    final eventsAsyncValue = ref.watch(eventsProvider);
    final interestedEventsAsyncValue = ref.watch(interestedEventsProvider);
    final goingEventsAsyncValue = ref.watch(goingEventsProvider);
    final userId = firebaseFunctions.getUserId();
    //final searchQuery = ref.watch(searchQueryProvider);
    final List<EventModel> allEvents = eventsAsyncValue.value ?? [];
    final List<EventModel> interestedEvents = interestedEventsAsyncValue.value ?? [];
    final List<EventModel> goinigEvents = goingEventsAsyncValue.value ?? [];

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final query = await showSearch<String>(
                    context: context,
                    delegate: EventSearchDelegate(allEvents, interestedEvents, goinigEvents),
                  );
                  if (query != null) {
                    ref.read(searchQueryProvider.notifier).state = query;
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: eventsAsyncValue.when(
              data: (events) {
                return interestedEventsAsyncValue.when(
                  data: (interestedEvents) {
                    return goingEventsAsyncValue.when(
                      data: (goingEvents) {
                        final uniqueEventIds = <String>{};

                        final allEvents = <EventModel>[];
                        for (final event in events) {
                          if (!uniqueEventIds.contains(event.id)) {
                            allEvents.add(event);
                            uniqueEventIds.add(event.id);
                          }
                        }
                        for (final event in interestedEvents) {
                          if (!uniqueEventIds.contains(event.id)) {
                            allEvents.add(event);
                            uniqueEventIds.add(event.id);
                          }
                        }
                        for (final event in goingEvents) {
                          if (!uniqueEventIds.contains(event.id)) {
                            allEvents.add(event);
                            uniqueEventIds.add(event.id);
                          }
                        }

                        if (uniqueEventIds.isEmpty) {
                          return const Center(
                            child: Text('No events available.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: allEvents.length,
                          itemBuilder: (context, index) {
                            final event = allEvents[index];
                            final eventId = event.id;
                            final isInterested = interestedEvents.any((event) => event.id == eventId);
                            final isGoing = goingEvents.any((event) => event.id == eventId);
                            final interestedUsersCountAsyncValue = ref.watch(interestedUsersCountProvider(eventId));
                            final goingUsersCountAsyncValue = ref.watch(goingUsersCountProvider(eventId));

                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenWidth * 0.02),
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
                                        Expanded(child: Text('Location: ${event.location}', overflow: TextOverflow.ellipsis,)),
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
                                    Text('Description: ${event.description ?? "No description provided"}'),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: Colors.black38,
                                            elevation: 0,
                                            margin: EdgeInsets.all(screenWidth * 0.02),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        isInterested ? Icons.star : Icons.star_border,
                                                        color: isInterested ? Colors.yellow : null,
                                                      ),
                                                      onPressed: () async {
                                                        if (userId != null) {
                                                          await firebaseFunctions.updateUserInterest(userId.toString(), eventId, !isInterested);
                                                          ref.read(starProvider(index).notifier).toggleStar();
                                                        }
                                                      },
                                                    ),
                                                    Text(isInterested ? 'Not Interested' : 'Interested'),
                                                  ],
                                                ),
                                                interestedUsersCountAsyncValue.when(
                                                  data: (count) {
                                                    return Text('Interested Users: $count');
                                                  },
                                                  loading: () {
                                                    return const CircularProgressIndicator();
                                                  },
                                                  error: (error, stackTrace) {
                                                    return const Text('Error fetching interested users count');
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Colors.black38,
                                            elevation: 0,
                                            margin: EdgeInsets.all(screenWidth * 0.02),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        isGoing ? Icons.check_circle : Icons.check_circle_outline,
                                                        color: isGoing ? Colors.green : null,
                                                      ),
                                                      onPressed: () async {
                                                        if (userId != null) {
                                                          await firebaseFunctions.updateUserGoing(userId.toString(), eventId, !isGoing);
                                                          ref.read(goingProvider(index).notifier).toggleGoing();
                                                        }
                                                      },
                                                    ),
                                                    Text(isGoing ? 'Not Going' : 'Going'),
                                                  ],
                                                ),
                                                goingUsersCountAsyncValue.when(
                                                  data: (count) {
                                                    return Text('Going Users: $count');
                                                  },
                                                  loading: () {
                                                    return const CircularProgressIndicator();
                                                  },
                                                  error: (error, stackTrace) {
                                                    return const Text('Error fetching going users count');
                                                  },
                                                ),
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
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => Center(
                        child: Text('Error: $error'),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('Error: $error'),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}