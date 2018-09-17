import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {

  WebViewPage({Key key, this.url = null}) : super(key: key);

  final String url;

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  @override
  Widget build(BuildContext context) {
    return  new WebviewScaffold(
      url: widget.url,
      appBar: new AppBar(
        title: new Text("Authenticate"),
      ),
    );
  }
}