import 'package:share/share.dart';

class EventModel {
  String id;
  String title;
  String details;
  String date;
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
          //date: (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
          date: json['date'],
          location: json['location'],
          description: json['description']); // Assign null if not present in JSON

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title":title,
      "details":details,
      //"date":Timestamp.fromDate(date),
      "date":date,
      "location":location,
      "description": description, // Include description in toJson
    };}
}

void shareEvent(EventModel event) {
  // Define the content to share
  final String text = 'Check out this event: ${event.title}\nDate: ${event.date}\nLocation: ${event.location}';

  // Share event details using Flutter's share functionality
  Share.share(text);
}
