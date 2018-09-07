import 'package:flutter/material.dart';

class CreateFilterPage extends StatefulWidget {
  CreateFilterPage({Key key}) : super(key: key);

  @override
  _CreateFilterPageState createState() => _CreateFilterPageState();
}

class _CreateFilterPageState extends State<CreateFilterPage> {

  final nameTextController = TextEditingController();
  final categoryTextController = TextEditingController();
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();
  bool _isUsedState = true;
  bool _isNewState = true;

  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new filter'),
      ),
      body: Builder(
          builder: (BuildContext context) {
            _scaffoldContext = context;
            return _body();
          }
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _createNameInput(),
          _createCategoryInput(),
          _createPriceInput(),
          _createIsUsedCheckbox(),
          Expanded(child: Container()),
          _createSaveButton()
        ],
      ),
    );
  }

  Widget _applyInputStyle(Widget input) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [new BoxShadow(
            color: Color.fromARGB(70, 0, 0, 0),
            blurRadius: 2.0,
          )
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: input
      ),
    );
  }

  Widget _createNameInput() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: _applyInputStyle(
            TextField(
              controller: nameTextController,
              decoration: InputDecoration.collapsed(
                hintText: "Filter name",
              ),
            )
        ));
  }

  Widget _createCategoryInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: _applyInputStyle(
            TextField(
              controller: categoryTextController,
              decoration: InputDecoration.collapsed(
                hintText: "Category",
              ),
            )
        ));
  }

  Widget _createPriceInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
            child:
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
                child: _applyInputStyle(
                    TextField(
                      controller: priceFromController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                          hintText: "Price from"
                      ),
                    )
                )
            )
        ),

        Flexible(
            child:
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: _applyInputStyle(
                    TextField(
                      controller: priceToController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                          hintText: "Price to"
                      ),)
                )
            )
        )

      ],
    );
  }

  Widget _createIsUsedCheckbox() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isUsedState,
                      onChanged: (value) {
                        setState(() {
                          _isUsedState = value;
                        });
                      },
                    ), Text("Search for used")
                  ]
              )
          ),

          Flexible(
              child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isNewState,
                      onChanged: (value) {
                        setState(() {
                          _isNewState = value;
                        });
                      },
                    ), Text("Search for new")
                  ]
              )
          ),

          Container(
            padding: EdgeInsets.all(16.0),
          )
        ]);
  }

  Widget _createSaveButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: FlatButton(
                    child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.green,
                    onPressed: () {
                      _saveFilter();
                    },
                  )
              )
          )
        ]);
  }

  void _saveFilter() {
    var text = nameTextController.text
        + ", " + priceFromController.text
        + ", " + priceToController.text
        + ", " + (_isUsedState ? "Used" : "New");
    Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }
}