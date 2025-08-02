import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_menu.dart';
import 'team_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TeamState(),
      child: MaterialApp(
        title: 'Volleyball Rotation',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MainMenu(),
      ),
    );
  }
}

