import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/models/event_model.dart';

class FirebaseFunctions {

  CollectionReference<EventModel> getEventCollection() {
    return FirebaseFirestore.instance
        .collection("Events")
        .withConverter<EventModel>(fromFirestore: (snapshot, _) {
      return EventModel.fromJson(snapshot.data()!);
    }, toFirestore: (value, _) {
      return value.toJson();
    });
  }
  void addEvent(EventModel eventModel) {
    var collection = getEventCollection();
    var docRef = collection.doc();
    eventModel.id = docRef.id;
    docRef.set(eventModel);
  }



 /* final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User signed up successfully
      User? user = userCredential.user;
      // You can perform additional tasks here, such as saving user data to Firestore
    } catch (e) {
      // Handle signup errors
      print('Signup error: $e');
    }
  }*/


}