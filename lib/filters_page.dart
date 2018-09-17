import 'dart:async';
import 'package:flutter/material.dart';
import 'package:allegro_observer/repository/repository.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/counter_widget.dart';
import 'allegro/token_storage.dart';
import 'webview_page.dart';
import 'allegro/authenticator.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({Key key}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {

  final mediumScale = 0.8;
  final smallScale = 0.7;

  List<Filter> _filters;

  void _openCreateFilter(BuildContext context) async {
    var filter = await Navigator.pushNamed(context, '/create_filter');
    if (filter != null) {
      var repository = Repository();
      await repository.open();
      await repository.addFilter(filter);
      await repository.close();
      _refreshList();
    }
  }

  void _refreshList() {
    setState(() {
      _filters.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    checkToken();
  }

  void checkToken() async {
    if (await TokenStorage().hasToken() == false) {
      var authenticator = Authenticator();

      var flutterWebViewPlugin = FlutterWebviewPlugin();
      flutterWebViewPlugin.onUrlChanged.listen((String url) {
        var code = authenticator.extractCode(url);
        if (code != null) {

          print("Code: $code");
        }
      });

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              WebViewPage(url: authenticator.getAuthUrl()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allegro Observer"),
      ),
      body: FutureBuilder(
        future: _buildFiltersListFuture(),
        builder: (BuildContext context, AsyncSnapshot<List<Filter>> snapshot) {
          return _handleFuture(context, snapshot);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCreateFilter(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Filter>> _buildFiltersListFuture() async {
    var repository = Repository();
    await repository.open();
    var list = await repository.fetchFilters();
    await repository.close();
    return list;
  }

  Widget _handleFuture(BuildContext context,
      AsyncSnapshot<List<Filter>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.data == null || snapshot.data.isEmpty) {
          return _buildEmptyView();
        } else {
          this._filters = snapshot.data;
          return _buildFiltersList(context, snapshot.data);
        }
    }
  }

  Widget _buildFiltersList(BuildContext context, List<Filter> filters) {
    return ListView.builder(
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
                title: _buildListItem(context, filters[index])
            ),
            Divider(height: 2.0),
          ],
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, Filter filter) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("[${filter.category.name}]",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: mediumScale,
                    ),
                    Padding(padding: EdgeInsets.all(2.0)),
                    _buildKeyword(filter),
                    _buildCheckboxes(filter)
                  ],
                ),
                Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: _buildPrice(filter)
                      )
                    ]
                )
              ]
          ),
          _buildCounter(filter)
        ]);
  }

  Widget _buildCounter(Filter filter) {
    return CounterWidget(filter);
  }

  Widget _buildKeyword(Filter filter) {
    if (filter.hasKeyword()) {
      return
        Row(
            children: <Widget>[
              Text(
                  "\"${filter.keyword}\"",
                  textScaleFactor: mediumScale
              ),
              Padding(
                  padding: EdgeInsets.only(left: 2.0)
              )
            ]);
    } else {
      return Container();
    }
  }

  Widget _buildPrice(Filter filter) {
    String value = "";
    if (filter.hasPriceFrom() && filter.hasPriceTo()) {
      value =
      "Price from ${filter.priceFromInt()}zł to ${filter.priceToInt()}zł";
    } else if (filter.hasPriceFrom()) {
      value = "Price from ${filter.priceFromInt()}zł";
    } else if (filter.hasPriceTo()) {
      value = "Price to ${filter.priceToInt()}zł";
    } else {
      return Container();
    }
    return Text(value, textScaleFactor: smallScale);
  }

  Widget _buildCheckboxes(Filter filter) {
    String text = filter.searchUsed
        ? "(Used"
        : "(New";
    if (filter.searchNew && filter.searchUsed) {
      if (filter.searchInDescription) {
        text = "(In description";
      }
      else {
        return Container();
      }
    }
    if (filter.searchInDescription) {
      text += ", In description";
    }
    return Text("$text)", textScaleFactor: mediumScale);
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Text("No filters"),
    );
  }
}