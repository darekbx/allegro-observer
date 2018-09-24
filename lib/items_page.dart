import 'package:flutter/material.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/listing_wrapper.dart';
import 'package:allegro_observer/allegro/model/items_wrapper.dart';
import 'package:allegro_observer/allegro/model/item.dart';
import 'package:allegro_observer/allegro/allegro_search.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({Key key, this.filter}) : super(key: key);

  final Filter filter;

  @override
  State<StatefulWidget> createState() => _ItemsPageSate();
}

class _ItemsPageSate extends State<ItemsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
      ),
      body: FutureBuilder(
          future: AllegroSearch().search(widget.filter),
          builder: (BuildContext context,
              AsyncSnapshot<ListingWrapper> snapshot) {
            return _handleShapshot(context, snapshot);
          }),
    );
  }

  Widget _handleShapshot(BuildContext context,
      AsyncSnapshot<ListingWrapper> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.data == null) {
          return _buildError("Error :(");
        } else {
          return _buildListView(context, snapshot.data.items);
        }
    }
  }

  _buildListView(BuildContext context, ItemsWrapper wrapper) {
    List<Item> items = [];
    items.addAll(wrapper.regular);
    items.addAll(wrapper.promoted);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: _buildListItem(context, items[index]),
            ),
            Divider(height: 2.0),
          ],
        );
      },
    );
  }

  _buildListItem(BuildContext context, Item item) {
    return

      GestureDetector(
          onTap: () {

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text("${item.name}", overflow: TextOverflow.ellipsis)
              ),
              Text("${item.id}", overflow: TextOverflow.ellipsis)
            ],
          )
      );
  }

  _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError(String errorMessage) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(errorMessage),
    );
  }
}