import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:allegro_observer/repository/repository.dart';
import 'package:allegro_observer/model/filter.dart';

class CounterWidget extends StatefulWidget {
  final Filter filter;

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
    var result = 0;
    await Future.delayed(Duration(milliseconds: Random().nextInt(900) + 1000));
    setState(() {
      widget.filter.count = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.filter.count;
    if (value == null) {
      return _buildLoadingView();
    } else if (value == 0) {
      return Container();
    }
    return Container(
      child: Text(
          "$value",
          textScaleFactor: mediumScale,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          )
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.blue
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