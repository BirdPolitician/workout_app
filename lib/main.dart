import 'package:flutter/material.dart';
import 'package:workout_app/screens/home_screen.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  //initialsing hive
  await Hive.initFlutter();

  //Opening the box
  await Hive.openBox('monday');
  await Hive.openBox('tuesday');
  await Hive.openBox('wednesday');
  await Hive.openBox('thursday');
  await Hive.openBox('friday');
  await Hive.openBox('saturday');
  await Hive.openBox('sunday');
  await Hive.openBox('sacrificialLamb');
  await Hive.openBox('weight');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'Getting Shredded',
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(scaffoldBackgroundColor: backgroundColor),
        home: const HomeScreen(),);
  }
}
