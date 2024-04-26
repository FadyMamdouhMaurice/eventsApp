import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/shared/firebase_functions.dart';

// Define a class for managing the theme
class MyTheme {
  final bool dark;

  const MyTheme({
    this.dark = false,
  });

  // Create a copy of the current theme with optional modifications
  MyTheme copy({
    bool? dark,
  }) =>
      MyTheme(
        dark: dark ?? this.dark,
      );
}

// Provider for managing the theme state
final themeProvider =
    StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

// Notifier for managing the theme state
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  // Toggle the theme between light and dark mode
  void toggleTheme() {
    state = !state;
  }
}

// Provider for managing the list of events
final eventListProvider =
    StateNotifierProvider<EventListNotifier, List<EventModel>>(
        (ref) => EventListNotifier());

// Notifier for managing the list of events
class EventListNotifier extends StateNotifier<List<EventModel>> {
  EventListNotifier() : super([]);

  // Add a new event to the list
  void addEvent(EventModel event) {
    state = [...state, event];
  }
}

// Provider for managing the index of the bottom navigation bar
final bottomNavigationBarIndexProvider = StateProvider<int>((ref) => 0);

// Provider for accessing Firebase functions
final firebaseFunctionsProvider = Provider((ref) => FirebaseFunctions());

// Provider for fetching all events from Firebase
final eventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.viewEvents();
});

// Provider for managing the star (interested) state of an event
final starProvider =
    StateNotifierProvider.family<StarNotifier, bool, int>((ref, eventId) {
  return StarNotifier(eventId: eventId);
});

// Notifier for managing the star (interested) state of an event
class StarNotifier extends StateNotifier<bool> {
  final int eventId;

  StarNotifier({required this.eventId}) : super(false);

  // Toggle the star state of the event
  void toggleStar() {
    state = !state;
  }
}

// Provider for managing the going state of an event
final goingProvider =
    StateNotifierProvider.family<goingNotifier, bool, int>((ref, eventId) {
  return goingNotifier(eventId: eventId);
});

// Notifier for managing the going state of an event
class goingNotifier extends StateNotifier<bool> {
  final int eventId;

  goingNotifier({required this.eventId}) : super(false);

  // Toggle the going state of the event
  void toggleGoing() {
    state = !state;
  }
}

// Provider for fetching events the user is interested in For View Event Screen
final interestedEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final userId = firebaseFunctions.getUserId();
  if (userId != null) {
    return firebaseFunctions.getInterestedEventsStream(userId.toString());
  } else {
    return Stream.value([]);
  }
});

// Provider for checking if a specific event is marked as interested by the user For View Event Screen
final isEventInterestedProvider =
    StreamProvider.family<bool, String>((ref, eventId) {
  final interestedEventsStream = ref.watch(interestedEventsProvider.stream);
  return interestedEventsStream.map((interestedEvents) =>
      interestedEvents.any((event) => event.id == eventId));
});

// Provider for fetching the count of users interested in a specific event For View Event Screen
final interestedUsersCountProvider =
    StreamProvider.family<int, String>((ref, eventId) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.getInterestedUsersCountStream(eventId);
});

// Provider for fetching events the user is going to attend For View Event Screen
final goingEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final userId = firebaseFunctions.getUserId();
  if (userId != null) {
    return firebaseFunctions.getGoingEventsStream(userId.toString());
  } else {
    return Stream.value([]);
  }
});

// Provider for checking if a specific event is marked as going by the user For View Event Screen
final isEventGoingProvider =
    StreamProvider.family<bool, String>((ref, eventId) {
  final goingEventsStream = ref.watch(goingEventsProvider.stream);
  return goingEventsStream
      .map((goingEvents) => goingEvents.any((event) => event.id == eventId));
});

// Provider for fetching the count of users going to a specific event For View Event Screen
final goingUsersCountProvider =
    StreamProvider.family<int, String>((ref, eventId) {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.getGoingUsersCountStream(eventId);
});

// Provider for managing the search query
final searchQueryProvider = StateProvider<String>((ref) => '');


// Provider for checking if a specific event is marked as interested by the user For Search Screen
final isSearchedEventInterestedProvider = Provider.family<bool, String>((ref, eventId) {
  final interestedEventsStream = ref.watch(interestedEventsProvider);
  return interestedEventsStream.maybeWhen(
    data: (interestedEvents) =>
        interestedEvents.any((event) => event.id == eventId),
    orElse: () => false,
  );
});


// Provider for checking if a specific event is marked as Going by the user For Search Screen
final isSearchedEventGoingProvider = Provider.family<bool, String>((ref, eventId) {
  final goingEventsStream = ref.watch(goingEventsProvider);
  return goingEventsStream.maybeWhen(
    data: (goingEvents) =>
        goingEvents.any((event) => event.id == eventId),
    orElse: () => false,
  );
});
