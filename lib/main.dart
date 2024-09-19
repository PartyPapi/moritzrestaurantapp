import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'restaurants_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Realtime Listener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RestaurantListPage(),
    );
  }
}
