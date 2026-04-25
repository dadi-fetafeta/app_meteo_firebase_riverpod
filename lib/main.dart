import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_api_meteo/UI/AuthPage.dart';
//import 'package:test_api_meteo/UI/AuthPage.dart';
//import 'package:test_api_meteo/UI/MeteoScreen.dart';
//import 'package:test_api_meteo/UI/MeteoScreen.dart';
import 'package:test_api_meteo/firebase_options.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Meteo API',
      theme: ThemeData(
       useMaterial3: true,
     
      ),
      home: const AuthPage(),
       //  home: const Meteoscreen(),
    );
  }
}


