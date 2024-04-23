import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/Screens/welcome_screen.dart';
import 'package:symstax_events/firebase_options.dart';
import 'package:symstax_events/shared/themes.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized(); //wait to init all package before run
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, child) {
        final isDarkModeEnabled = ref.watch(themeProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkModeEnabled ? MyThemeData.darkTheme(context) : MyThemeData.lightTheme(context),
          home: WelcomeScreen(),
        );
      },
    );
  }
}