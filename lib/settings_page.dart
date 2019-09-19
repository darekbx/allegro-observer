import 'package:flutter/material.dart';
import 'package:allegro_observer/repository/local/local_storage.dart';
import 'package:allegro_observer/allegro/authenticator.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  var _clientIdInputController = TextEditingController();
  var _clientSecretInputController = TextEditingController();
  var _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
    _clientIdInputController.addListener(() {
      _localStorage.setClientId(_clientIdInputController.text);
    });
    _clientSecretInputController.addListener(() {
      _localStorage.setClientSecret(_clientSecretInputController.text);
    });
  }

  @override
  void dispose() {
    _clientIdInputController.dispose();
    _clientSecretInputController.dispose();
    super.dispose();
  }

  void _loadData() async {
    var clientId = await _localStorage.getClientId();
    var clientSecret = await _localStorage.getClientSecret();
    setState(() {
      _clientIdInputController.text = clientId;
      _clientSecretInputController.text = clientSecret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Enter your Client Id"),
                TextField(
                  controller: _clientIdInputController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Client Id"),
                ),
                Text("Enter your Client Secret"),
                TextField(
                  controller: _clientSecretInputController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Client Secret"),
                ),
                FlatButton(child: Text("Authorize"), onPressed: () => _authorize(context)),
              ],
            )));
  }

  void _authorize(BuildContext context) async {
    var authenticator = Authenticator(_clientIdInputController.text, _clientSecretInputController.text);
    var verificationUrl = await authenticator.getVerificationUrl();

    _openUrl(context, verificationUrl);
  }

  _openUrl(BuildContext context, String url) async {
    await Future.delayed(Duration(seconds: 1));
    if (await canLaunch(url)) {
      await launch(url);
    }
    Navigator.pop(context);
  }
}