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
  final FocusNode _clientIdFocusNode = FocusNode();
  final FocusNode _clientSecretFocusNode = FocusNode();
  var _clientIdInputController = TextEditingController();
  var _clientSecretInputController = TextEditingController();
  var _localStorage = LocalStorage();

  var _clientIdValidation = false;
  var _clientSecretValidation = false;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      _loadData();
      _clientIdFocusNode.addListener(() { 
        setState(() {
          _clientIdValidation = _clientIdInputController.text.isEmpty;
        });
      });
      _clientSecretFocusNode.addListener(() {
        setState(() {
          _clientSecretValidation =_clientSecretInputController.text.isEmpty;
        });
      });
      _clientIdInputController.addListener(() {
        _localStorage.setClientId(_clientIdInputController.text);
      });
      _clientSecretInputController.addListener(() {
        _localStorage.setClientSecret(_clientSecretInputController.text);
      });
    }
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
                Padding(
                    child: Text("Enter your Client Id"),
                    padding: EdgeInsets.only(top: 4)),
                showClientIdInput(),
                Padding(
                    child: Text("Enter your Client Secret"),
                    padding: EdgeInsets.only(top: 24)),
                showClientSecretInput(),
                Padding(
                    child: RaisedButton(
                        child: Text("Authorize"),
                        onPressed: () => _authorize(context)),
                    padding: EdgeInsets.only(top: 24)),
              ],
            )));
  }

  Widget showClientIdInput() {
    var decoration;
    if (_clientIdValidation) {
      decoration = InputDecoration(hintText: "Client Id", errorText: "Value should not be empty");
    } else {
      decoration = InputDecoration(hintText: "Client Id");
    }
    return TextField(
                  controller: _clientIdInputController,
                  keyboardType: TextInputType.text,
                  decoration: decoration,
                  focusNode: _clientIdFocusNode,
                );
  }

  Widget showClientSecretInput() {
    var decoration;
    if (_clientSecretValidation) {
      decoration = InputDecoration(hintText: "Client Secret", errorText: "Value should not be empty");
    } else {
      decoration = InputDecoration(hintText: "Client Secret");
    }
    return TextField(
                  controller: _clientSecretInputController,
                  keyboardType: TextInputType.text,
                  decoration: decoration,
                  focusNode: _clientSecretFocusNode,
                );
  }
  void _authorize(BuildContext context) async {
    if (_clientIdInputController.text.isEmpty ||
        _clientSecretInputController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('ClientId and ClientSecret should be not empty.')));
      return;
    }

    var authenticator = Authenticator(
        _clientIdInputController.text, _clientSecretInputController.text);
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
