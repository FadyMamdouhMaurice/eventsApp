import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Events/add_event.dart';
import 'package:symstax_events/Events/view_event.dart';
import 'package:symstax_events/Provider/riverpod.dart';

final bottomNavigationBarIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, watch) {
    final myTheme = watch.read(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(myTheme ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () {
              watch.read(themeProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final currentIndex = ref.watch(bottomNavigationBarIndexProvider);
          return IndexedStack(
            index: currentIndex,
            children: [
              AddEventScreen(),
              ViewEventScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class BottomNavBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final currentIndex = ref.watch(bottomNavigationBarIndexProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        print(index);
        ref
            .read(bottomNavigationBarIndexProvider.notifier)
            .update((state) => index);
      },
      items: [
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
