import 'package:flutter/material.dart';
import 'package:allegro_observer/repository/repository.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({Key key}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {

  void _openCreateFilter(BuildContext context) async {

    var filter = await Navigator.pushNamed(context, '/create_filter');
    if (filter != null) {

      var repository = Repository();
      await repository.open();

      var id = await repository.addFilter(filter);

      print("New filter $id");

      var list = await repository.fetchFilters();

      list.forEach((f) => print(f));

      await repository.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allegro Observer"),
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
