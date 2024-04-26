import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';

const kGoogleApiKey = "AIzaSyBQMVPfuo3bVHEvjRn0z_K36Ao8KCEjioY"; // Google API key

class MapScreen extends StatefulWidget {
  final EventModel event; // Event model passed to the map screen

  const MapScreen({required this.event}); // Constructor for MapScreen widget

  @override
  State<MapScreen> createState() => _MapScreenState(); // Create state for MapScreen
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> markersList = {}; // Set to hold markers on the map
  LatLng? eventLocation; // Variable to hold the event location

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>(); // Completer for controlling Google Map

  GoogleMapController? googleMapController; // Controller for Google Map
  Position? currentPositionOfUser; // Current position of the user
  TextEditingController _searchController = TextEditingController(); // Controller for search input field

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Search input field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.08,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search for a location',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchLocation(_searchController.text); // Search for the location
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Google Map
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(30.0444, 31.2357),
                    zoom: 12,
                  ),
                  markers: markersList, // Set of markers on the map
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    googleMapController = controller; // Initialize Google Map controller
                    getCurrentLiveLocationOfUser(); // Get current location of the user
                  },
                ),
              ),
            ),
            // Done button
            SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.08,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                child: MyButtonWidget(
                  onClicked: () async {
                    if (eventLocation != null) {
                      print (widget.event.date);
                      await FirebaseFunctions().addEvent(widget.event); // Add event to Firebase
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()), // Navigate to home screen
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please choose event Location'),
                        ),
                      ); // Show snackbar if event location is not selected
                    }
                  },
                  text: 'Done',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create markers
  Set<Marker> _createMarkers() {
    return {
      const Marker(
        markerId: MarkerId('event_location'),
        position: LatLng(30.0444, 31.2357),
        infoWindow: InfoWindow(title: 'Event Location'),
      ),
      // Add more markers for other event locations if needed
    };
  }

  // Function to search for a location
  Future<void> _searchLocation(String query) async {
    try {
      // Fetch predictions based on user query
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);
        eventLocation = searchedLocation;
        widget.event.location = searchedLocation.toString(); // Update event location
        _moveToLocation(searchedLocation); // Move camera to searched location

        // Add marker at searched location
        markersList.add(
          Marker(
            markerId: const MarkerId('searched_location'),
            position: searchedLocation,
            infoWindow: const InfoWindow(title: 'Searched Location'),
          ),
        );

        setState(() {}); // Trigger rebuild to reflect marker addition
      } else {
        // No location found
      }
    } catch (e) {
      // Error searching location
    }
  }

  // Function to move camera to a location
  Future<void> _moveToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  // Function to get current live location of the user
  getCurrentLiveLocationOfUser() async {
    try {
      Position positionOfUSer = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPositionOfUser = positionOfUSer;
      LatLng positionOfUSerLatLng = LatLng(
          currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
      CameraPosition cameraPosition =
      CameraPosition(target: positionOfUSerLatLng, zoom: 15);
      googleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition)); // Move camera to current user location
    } catch (e) {
      // Error getting current location
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }
}
