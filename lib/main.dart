import 'package:flutter/material.dart';
import 'package:allegro_observer/FiltersPage.dart';

void main() => runApp(new AllegroObserverApp());

class AllegroObserverApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new FiltersPage(title: 'Allegro Observer'),
    );
  }
}
