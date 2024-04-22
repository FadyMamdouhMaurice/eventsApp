import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/firebase_functions.dart';

FirebaseFunctions firebaseFunctions = FirebaseFunctions();

class ViewEventScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsyncValue = ref.watch(eventsProvider);
    final interestedEventsAsyncValue = ref.watch(interestedEventsProvider);
    final userId = firebaseFunctions.getUserId();

    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: eventsAsyncValue.when(
        data: (events) {
          return interestedEventsAsyncValue.when(
            data: (interestedEvents) {
              if (events.isEmpty && interestedEvents.isEmpty) {
                return Center(
                  child: Text('No events available.'),
                );
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final starNotifier = ref.watch(starProvider(index));
                  final goingNotifier = ref.watch(goingProvider(index));

                  final eventId = event.id; // Get the event ID from the EventModel object
                  final isInterested = interestedEvents.any((event) => event.id == eventId);

/*
                  // Fetch interested users count only if the event is interested
                  final interestedUsersCountAsyncValue = isInterested
                      ? ref.watch(interestedUsersCountProvider(event.id))
                      : AsyncValue.data(0); // Assume 0 interested users if not interested
*/

                  final interestedUsersCountAsyncValue = ref.watch(interestedUsersCountProvider(starNotifier.toString()));

                  //final interestedNotifier = ref.watch(isEventInterestedProvider(eventId));
                  //final interestedUsersCountAsyncValue = ref.watch(interestedUsersCountProvider(event.id));

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
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
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(starNotifier ? Icons.star : Icons.star_border,
                                              color: starNotifier ? Colors.yellow : null, // Change color when starred
                                            ),
                                            onPressed: () async {
                                              // Handle interested event logic
                                              if (userId != null) {
                                                ref.read(starProvider(index).notifier).toggleStar(); // Toggle starred state
                                                await firebaseFunctions.updateUserInterest(userId!, eventId, !starNotifier);
                                              }
                                            },
                                          ),
                                          Text(starNotifier ? 'Not Interested' : 'Interested'),
                                        ],
                                      ),
                                      // Display interested users count
                                      interestedUsersCountAsyncValue.when(
                                        data: (count) {
                                          return Text('Interested Users: $count');
                                        },
                                        loading: () {
                                          return CircularProgressIndicator(); // Show loading indicator while fetching data
                                        },
                                        error: (error, stackTrace) {
                                          return Text('Error fetching interested users count'); // Show error message if fetching fails
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(goingNotifier ? Icons.check_circle : Icons.check_circle_outline,
                                        color: goingNotifier? Colors.green : null), // Use different icon for "going"
                                        onPressed: () {
                                          // Handle going event logic
                                          ref.read(goingProvider(index).notifier).toggleGoing(); // Toggle starred state
                                        },
                                      ),
                                      Text(goingNotifier ? 'Not Going' : 'Going'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // You can add more UI components here
                    ),
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}