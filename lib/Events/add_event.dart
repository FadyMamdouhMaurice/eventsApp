import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:symstax_events/Models/event_model.dart';
import 'package:symstax_events/Screens/map_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';
import 'package:intl/intl.dart';

final TextEditingController titleController = TextEditingController();
final TextEditingController detailsController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final selectedDateProvider = StateProvider<String>((ref) => 'Choose Date');
final FirebaseFunctions firebaseFunctions = FirebaseFunctions();

class AddEventScreen extends ConsumerWidget {
  AddEventScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //DateTime _selectedDate = DateTime.now();
  final userId = firebaseFunctions.getUserId().toString();

  @override
  Widget build(BuildContext context, ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final eventDate = ref.watch(selectedDateProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenWidth * 0.02),
              Flexible(
                child: TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: 'Details*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter details';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
              Flexible(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description'),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Row(
                children: [
                  Text(
                    eventDate,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  IconButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              // Adjust dialog width based on screen width
                              alwaysUse24HourFormat: false,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                // Adjust dialog theme to match app's theme
                                colorScheme: ColorScheme.light(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                                ),
                                dialogBackgroundColor: Theme.of(context).dialogBackgroundColor,
                                textTheme: Theme.of(context).textTheme.copyWith(
                                  // Adjust font size based on screen width
                                  titleMedium: TextStyle(fontSize: screenWidth * 0.04),
                                  labelLarge: TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                        },
                      );
                      if (pickedDate != null) {
                        ref.read(selectedDateProvider.notifier).state =
                            DateFormat('yyyy-MM-dd')
                                .format(pickedDate)
                                .toString();
                        //_selectedDate = pickedDate;
                      }
                    },
                    iconSize: screenWidth * 0.06,
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              Flexible(
                child: MyButtonWidget(
                  text: 'Choose Event Location',
                  onClicked: () async {
                    if (_formKey.currentState!.validate()) {
                      await Permission.locationWhenInUse.isDenied.then((value) {
                        if (value) {
                          Permission.locationWhenInUse.request();
                        }
                        final event = EventModel(
                          title: titleController.text,
                          description: descriptionController.text,
                          date: eventDate,
                          details: detailsController.text,
                          id: userId,
                          location: '',
                        );
                        titleController.clear();
                        descriptionController.clear();
                        detailsController.clear();
                        locationController.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapScreen(
                                    event: event,
                                  )),
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
