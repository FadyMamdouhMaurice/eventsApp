import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/Models/event_model.dart';

FirebaseFunctions firebaseFunctions = FirebaseFunctions();

class ViewEventScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final eventsAsyncValue = ref.watch(eventsProvider);
    final interestedEventsAsyncValue = ref.watch(interestedEventsProvider);
    final goingEventsAsyncValue = ref.watch(goingEventsProvider);
    final userId = firebaseFunctions.getUserId();

    return Scaffold(
      body: eventsAsyncValue.when(
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

                  if (allEvents.isEmpty) {
                    return Center(
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
                          title: Text(event.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.details),
                              Text('Location: ${event.location}'),
                              Text('Date: ${event.date.toString()}'),
                              Text('Description: ${event.description ?? "No description provided"}'),
                              Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 4,
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
                                                    if (isInterested) {
                                                      await firebaseFunctions.updateUserInterest(userId!, eventId, false);
                                                    } else {
                                                      await firebaseFunctions.updateUserInterest(userId!, eventId, true);
                                                    }
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
                                              return CircularProgressIndicator();
                                            },
                                            error: (error, stackTrace) {
                                              return Text('Error fetching interested users count');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      elevation: 4,
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
                                                    if (isGoing) {
                                                      await firebaseFunctions.updateUserGoing(userId!, eventId, false);
                                                    } else {
                                                      await firebaseFunctions.updateUserGoing(userId!, eventId, true);
                                                    }
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
                                              return CircularProgressIndicator();
                                            },
                                            error: (error, stackTrace) {
                                              return Text('Error fetching going users count');
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
