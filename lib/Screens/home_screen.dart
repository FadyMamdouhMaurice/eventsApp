import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Events/add_event.dart';
import 'package:symstax_events/Events/view_event.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/Screens/login_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';

final bottomNavigationBarIndexProvider = StateProvider<int>((ref) => 0);
FirebaseFunctions firebaseFunctions = FirebaseFunctions();
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context, watch) {
    final myTheme = watch.read(themeProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Home'),
        ),
        automaticallyImplyLeading: false, // This line removes the back arrow
        actions: [
          IconButton(
            icon: Icon(myTheme ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () {
              watch.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with the actual next screen
              );
            },
          ),

        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final currentIndex = ref.watch(bottomNavigationBarIndexProvider);
          return IndexedStack(
            index: currentIndex,
            children: [
              AddEventScreen(),
              const ViewEventScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentIndex = ref.watch(bottomNavigationBarIndexProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref
            .read(bottomNavigationBarIndexProvider.notifier)
            .update((state) => index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'View Events',
        ),
      ],
    );
  }
}
