import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';
import 'package:intl/intl.dart';

final TextEditingController _titleController = TextEditingController();
final TextEditingController _detailsController = TextEditingController();
final TextEditingController _locationController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

class AddEventScreen extends ConsumerWidget {
  AddEventScreen({super.key});

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final FirebaseFunctions firebaseFunctions = FirebaseFunctions();
  final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

  @override
  Widget build(BuildContext context, ref) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.02),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.02),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.02),
              TextFormField(
                controller: _descriptionController,
                decoration:
                InputDecoration(labelText: 'Description (optional)'),
              ),
              SizedBox(height: screenWidth * 0.04),
              Row(
                children: [
                  Text('Date:'),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    _selectedDate == null
                        ? 'Choose Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                  IconButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        _selectedDate = pickedDate;
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              MyButtonWidget(
                text: 'Submit',
                onClicked: () async {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  if (_formKey.currentState!.validate()) {
                    final event = EventModel(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      date: _selectedDate!,
                      details: _detailsController.text,
                      id: _auth.currentUser!.uid,
                    );
                    bool added = await FirebaseFunctions().addEvent(event);

                    if (added) {
                      ref.read(eventListProvider.notifier).addEvent(event);
                      _titleController.clear();
                      _descriptionController.clear();
                      _detailsController.clear();
                      _locationController.clear();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
