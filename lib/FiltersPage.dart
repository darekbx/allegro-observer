import 'package:flutter/material.dart';
import 'package:allegro_observer/CreateFilterPage.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {

  void _openCreateFilter(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateFilterPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _openCreateFilter(context); },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
