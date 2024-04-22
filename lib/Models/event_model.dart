import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String title;
  String details;
  DateTime date;
  String location;
  String? description;

  EventModel({required this.id,
    required this.title,
    required this.details,
    required this.date,
    required this.location,
    this.description, // Make description nullable in the constructor
  });

  EventModel.fromJson(Map<String, dynamic> json):
        this(
          id: json['id'],
          title: json['title'],
          details: json['details'],
          date: (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
          location: json['location'],
          description: json['description']); // Assign null if not present in JSON

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title":title,
      "details":details,
      "date":Timestamp.fromDate(date),
      "location":location,
      "description": description, // Include description in toJson
    };}
}