import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewEventMaP extends StatefulWidget {
  const ViewEventMaP({super.key, required this.eventLocation});
  final LatLng eventLocation; // Event location passed to the map screen

  @override
  State<ViewEventMaP> createState() => _ViewEventMaPState();
}

class _ViewEventMaPState extends State<ViewEventMaP> {

  Set<Marker> markersList = {}; // Set to hold markers on the map
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>(); // Completer for controlling Google Map
  GoogleMapController? googleMapController; // Controller for Google Map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Add marker at searched location
    markersList.add(
      Marker(
        markerId: const MarkerId('searched_location'),
        position: widget.eventLocation,
        infoWindow: const InfoWindow(title: 'Event Location'),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: widget.eventLocation,
                  zoom: 12,
                ),
                markers: markersList, // Set of markers on the map
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  googleMapController = controller; // Initialize Google Map controller
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    googleMapController?.dispose();
  }
}