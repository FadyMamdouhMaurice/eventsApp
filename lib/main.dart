import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Events/view_event.dart';
import 'package:symstax_events/Screens/signup_screen.dart';
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
        final isDarkModeEnabled = ref.read(themeProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkModeEnabled ? MyThemeData.darkTheme : MyThemeData.lightTheme,

          /*
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
      */
          home: WelcomeScreen(),
        );
      },
    );
  }
}