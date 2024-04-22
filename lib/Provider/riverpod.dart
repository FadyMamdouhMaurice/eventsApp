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

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleTheme() {
    state = !state;
    print(state);
  }
}

final eventListProvider = StateNotifierProvider<EventListNotifier, List<EventModel>>((ref) => EventListNotifier());

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
final starProvider = StateNotifierProvider.family<StarNotifier,bool, int>((ref, eventId) => StarNotifier());

class StarNotifier extends StateNotifier<bool> {

  StarNotifier() : super(false);
  void toggleStar() {
    state = !state;
  }
}


// Going Event Provider
final goingProvider = StateNotifierProvider.family<goingNotifier,bool, int>((ref, eventId) => goingNotifier());

class goingNotifier extends StateNotifier<bool> {
  goingNotifier() : super(false);

  void toggleGoing() {
    state = !state;
  }
}


final interestedEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  final userId = firebaseFunctions.getUserId();
  if (userId != null) {
    // Fetch the events the user is interested in
    return firebaseFunctions.getInterestedEvents(userId);
  } else {
    // User is not signed in, return an empty list
    return [];
  }
});

final isEventInterestedProvider = Provider.family<bool, String>((ref, eventId) {
  final interestedEventsAsyncValue = ref.watch(interestedEventsProvider);
  return interestedEventsAsyncValue.when(
    data: (interestedEvents) {
      return interestedEvents.any((event) => event.id == eventId);
    },
    loading: () => false, // Assume not interested if loading
    error: (error, stackTrace) {
      print('Error checking if event is interested: $error');
      return false; // Assume not interested if error
    },
  );
});


final interestedUsersCountProvider = FutureProvider.family<int, String>((ref, eventId) async {
  final firebaseFunctions = ref.read(firebaseFunctionsProvider);
  return firebaseFunctions.getInterestedUsersCount(eventId);
});