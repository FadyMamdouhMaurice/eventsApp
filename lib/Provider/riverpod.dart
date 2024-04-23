import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/shared/firebase_functions.dart';

class MyTheme {
  final bool dark;

  const MyTheme({
    this.dark = false,
  });

  MyTheme copy({
    bool? dark,
  }) =>
      MyTheme(
        dark: dark ?? this.dark,
      );
}
final themeProvider =
StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleTheme() {
    state = !state;
  }
}

final eventListProvider =
    StateNotifierProvider<EventListNotifier, List<EventModel>>(
        (ref) => EventListNotifier());

class EventListNotifier extends StateNotifier<List<EventModel>> {
  EventListNotifier() : super([]);

  void addEvent(EventModel event) {
    state = [...state, event];
  }
}

// bottomNavigationBar Provider
final bottomNavigationBarIndexProvider = StateProvider<int>((ref) => 0);

final firebaseFunctionsProvider = Provider((ref) => FirebaseFunctions());

final eventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.viewEvents();
});

// Interested Event Provider
final starProvider =
    StateNotifierProvider.family<StarNotifier, bool, int>((ref, eventId) {
  // Pass a default value directly or define it before this line if it needs to be dynamic
  return StarNotifier(eventId: eventId);
});

class StarNotifier extends StateNotifier<bool> {
  final int eventId;

  // Make sure the constructor parameters match the named arguments you're using
  StarNotifier({required this.eventId}) : super(false);

  void toggleStar() {
    state = !state;
    // Now you can use eventId here as needed
  }
}

// Going Event Provider
final goingProvider =
StateNotifierProvider.family<goingNotifier, bool, int>((ref, eventId) {
  // Pass a default value directly or define it before this line if it needs to be dynamic
  return goingNotifier(eventId: eventId);
});

class goingNotifier extends StateNotifier<bool> {
  final int eventId;

  // Make sure the constructor parameters match the named arguments you're using
  goingNotifier({required this.eventId}) : super(false);

  void toggleGoing() {
    state = !state;
    // Now you can use eventId here as needed
  }
}

final interestedEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final userId = firebaseFunctions.getUserId();
  if (userId != null) {
    // Fetch the events the user is interested in
    return firebaseFunctions.getInterestedEventsStream(userId);
  } else {
    // User is not signed in, return an empty stream
    return Stream.value([]);
  }
});

final isEventInterestedProvider =
    StreamProvider.family<bool, String>((ref, eventId) {
  final interestedEventsStream = ref.watch(interestedEventsProvider.stream);
  return interestedEventsStream.map((interestedEvents) =>
      interestedEvents.any((event) => event.id == eventId));
});

final interestedUsersCountProvider =
    StreamProvider.family<int, String>((ref, eventId) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.getInterestedUsersCountStream(eventId);
});


final goingEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final userId = firebaseFunctions.getUserId();
  if (userId != null) {
    // Fetch the events the user is interested in
    return firebaseFunctions.getGoingEventsStream(userId);
  } else {
    // User is not signed in, return an empty stream
    return Stream.value([]);
  }
});

final isEventGoingProvider =
StreamProvider.family<bool, String>((ref, eventId) {
  final goingEventsStream = ref.watch(goingEventsProvider.stream);
  return goingEventsStream.map((goingEvents) =>
      goingEvents.any((event) => event.id == eventId));
});

final goingUsersCountProvider =
StreamProvider.family<int, String>((ref, eventId) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.getGoingUsersCountStream(eventId);
});