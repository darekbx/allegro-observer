import 'package:flutter/material.dart';
import 'package:allegro_observer/allegro/allegro_categories.dart';
import 'package:allegro_observer/allegro/model/category_wrapper.dart';

class CategoryChoosePage extends StatefulWidget {
  CategoryChoosePage({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() => _CategoryChooseState();
}

class _CategoryChooseState extends State<CategoryChoosePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Choose category")
        ),
        body: FutureBuilder(
            future: AllegroCategories().getMainCategories(),
            builder: (BuildContext context, AsyncSnapshot<CategoryWrapper> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Text("Loading...");
                default:
                  if (snapshot.hasError) {
                    return Text(snapshot.error);
                  } else {
                    if (snapshot.data == null) {
                      return Text("Error :( ");
                    } else {
                      return _buildListView(context, snapshot);
                    }
                  }
              }
            })
    );
  }

  _buildListView(BuildContext context, AsyncSnapshot<CategoryWrapper> snapshot) {
    CategoryWrapper wrapper = snapshot.data;
    return ListView.builder(
      itemCount: wrapper.categories.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(wrapper.categories[index].name),
            ),
            Divider(height: 2.0),
          ],
        );
      }
    );
  }
}