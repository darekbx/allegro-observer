import 'package:flutter/material.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/allegro_search.dart';

class CounterWidget extends StatefulWidget {
  final Filter filter;
  int count = null;
  bool isOverflow = false;

  CounterWidget(this.filter, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {

  final mediumScale = 0.8;

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {

    var allegroSearch = AllegroSearch();
    var result = await allegroSearch.search(widget.filter);

    setState(() {
      widget.count = result.items.regular.length + result.items.promoted.length;
      widget.isOverflow = result.isOverflow();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.count == null) {
      return _buildLoadingView();
    } else if (widget.count == 0) {
      return Container();
    }
    return Container(
      child: Text(
          "${widget.count}",
          textScaleFactor: mediumScale,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          )
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: widget.isOverflow ? Colors.red : Colors.blue
      ),
      padding: EdgeInsets.all(4.0),
    );
  }

  Widget _buildLoadingView() {
    return Container(height: 20.0, width: 20.0,
      child: CircularProgressIndicator(),
    );
  }
}