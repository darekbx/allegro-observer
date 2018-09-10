import 'package:flutter/material.dart';
import 'package:allegro_observer/filters_page.dart';
import 'package:allegro_observer/create_filter_page.dart';
import 'package:allegro_observer/category_choose_page.dart';

void main() => runApp(new AllegroObserverApp());

class AllegroObserverApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FiltersPage(),
        '/create_filter': (context) => CreateFilterPage(),
        '/category_choose': (context) => CategoryChoosePage()
      },
    );
  }
}
