import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malicious_android_app/animation_screen.dart';
import 'package:malicious_android_app/loading.dart';
import 'start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AndroShield',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: <Widget>[
      Scaffold(
          appBar: AppBar(
            title: Text('AndroShield'),
          ),
          body: ExampleStartScreen()),
      IgnorePointer(
          child: AnimationScreen(color: Theme.of(context).accentColor))
    ]));
  }
}
