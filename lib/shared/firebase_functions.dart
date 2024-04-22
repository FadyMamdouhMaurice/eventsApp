import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symstax_events/Models/event_model.dart';

class FirebaseFunctions {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID
  String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // User is not signed in
      return null;
    }
  }

  // Function to sign up a user with email and password
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User signed up successfully
      User? user = userCredential.user;
      // You can perform additional tasks here, such as saving user data to Firestore
      return true;
    } catch (e) {
      // Handle signup errors
      print('Signup error: $e');
      return false;
    }
  }

  // Function to login a user with email and password
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
      // Navigate to the next screen or do something else upon successful login
    } catch (e) {
      // Show an error message or handle the error appropriately
      print('Login error: $e');
      return false;
    }
  }

  // Get a reference to the collection of events in Firestore
  CollectionReference<EventModel> getEventCollection() {
    return FirebaseFirestore.instance
        .collection("Events")
        .withConverter<EventModel>(fromFirestore: (snapshot, _) {
      return EventModel.fromJson(snapshot.data()!);
    }, toFirestore: (value, _) {
      return value.toJson();
    });
  }

  // Function to add an event to Firestore
  Future<bool> addEvent(EventModel eventModel) async {
    var collection = getEventCollection();
    var docRef = collection.doc();
    eventModel.id = docRef.id;
    await docRef.set(eventModel);
    return true;
  }

  // Stream to listen to changes in the list of events
  Stream<List<EventModel>> viewEvents() {
    try {
      return getEventCollection().snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      print('Error retrieving events: $e');
      throw Exception('Failed to retrieve events: $e');
    }
  }

  // Function to update a user's interest in an event
  Future<void> updateUserInterest(String userId, String eventId,
      bool interested) async {
    try {
      // Get a reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users')
          .doc(userId);

      // Add or remove the event from the interests subcollection based on the interested status
      if (interested) {
        // Add the user ID to the event's interested_users subcollection
        DocumentReference eventRef = FirebaseFirestore.instance.collection(
            'Events').doc(eventId.toString());
        await eventRef.collection('interested_users').doc(userId).set({
          'user_id': userId,
        });

        // Add the event to the user's interests subcollection
        await userRef.collection('interests').doc(eventId.toString()).set({
          'event_id': eventId,
        });
      } else {
        // Remove the user ID from the event's interested_users subcollection
        DocumentReference eventRef = FirebaseFirestore.instance.collection(
            'Events').doc(eventId.toString());
        await eventRef.collection('interested_users').doc(userId).delete();

        // Remove the event from the user's interests subcollection
        await userRef.collection('interests').doc(eventId.toString()).delete();
      }
    } catch (e) {
      print('Error updating user interest: $e');
      throw Exception('Failed to update user interest: $e');
    }
  }

  // Function to fetch interested events for a user
  Future<List<EventModel>> getInterestedEvents(String userId) async {
    try {
      // Get a reference to the user's interests subcollection
      QuerySnapshot interestsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('interests')
          .get();

      // List to store the interested event IDs
      List<String> eventIds = interestsSnapshot.docs.map((doc) => doc.id)
          .toList();

      // List to store the interested events
      List<EventModel> interestedEvents = [];

      // Fetch the events using the IDs
      for (String eventId in eventIds) {
        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection('Events')
            .doc(eventId)
            .get();

        if (eventSnapshot.exists) {
          interestedEvents.add(EventModel.fromJson(
              eventSnapshot.data() as Map<String, dynamic>));
        }
      }

      return interestedEvents;
    } catch (e) {
      print('Error fetching interested events: $e');
      throw Exception('Failed to fetch interested events: $e');
    }
  }

  // Function to update a user's going status for an event
  Future<void> updateUserGoing(String userId, String eventId,
      bool going) async {
    try {
      // Get a reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users')
          .doc(userId);

      // Add or remove the event from the going subcollection based on the going status
      if (going) {
        // Add the user ID to the event's going_users subcollection
        DocumentReference eventRef = FirebaseFirestore.instance.collection(
            'Events').doc(eventId.toString());
        await eventRef.collection('going_users').doc(userId).set({
          'user_id': userId,
        });

        // Add the event to the user's going subcollection
        await userRef.collection('going').doc(eventId.toString()).set({
          'event_id': eventId,
        });
      } else {
        // Remove the user ID from the event's going_users subcollection
        DocumentReference eventRef = FirebaseFirestore.instance.collection(
            'Events').doc(eventId.toString());
        await eventRef.collection('going_users').doc(userId).delete();

        // Remove the event from the user's going subcollection
        await userRef.collection('going').doc(eventId.toString()).delete();
      }
    } catch (e) {
      print('Error updating user going: $e');
      throw Exception('Failed to update user going: $e');
    }
  }

  // Function to get the count of users interested in an event
  Future<int> getInterestedUsersCount(String eventId) async {
    try {
      // Get a reference to the interested_users subcollection of the event
      QuerySnapshot interestedUsersSnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .collection('interested_users')
          .get();

      // Return the count of documents in the interested_users subcollection
      return interestedUsersSnapshot.size;
    } catch (e) {
      print('Error getting interested users count: $e');
      throw Exception('Failed to get interested users count: $e');
    }
  }
}