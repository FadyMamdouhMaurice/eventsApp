class EventModel {
  String id;
  String title;
  String details;
  int date;
  String location;
  var description;

  EventModel({required this.id,
    required this.title,
    required this.details,
    required this.date,
    required this.location,
    this.description});

  EventModel.fromJson(Map<String, dynamic> json):
    this(
        id: json['id'],
        title: json['title'],
        details: json['details'],
        date: json['date'],
        location: json['location']);


  Map<String, dynamic> toJson() {
    return {
    "id": id,
    "title":title,
    "details":details,
    "date":date,
    "location":location,
  };}
}
