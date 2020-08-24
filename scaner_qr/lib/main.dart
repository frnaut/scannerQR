import 'package:flutter/material.dart';
import 'package:scaner_qr/pages/home_page.dart';
import 'package:scaner_qr/pages/map_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScanerQr',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "home",
      routes: {
        "home": (BuildContext context) => HomePage(),
        "map": (BuildContext context) => MapPage()
      },
    );
  }
}
