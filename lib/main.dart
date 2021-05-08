import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:typeahead/service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TypeAhead()
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TypeAhead extends StatefulWidget {
  @override
  _TypeAheadState createState() => _TypeAheadState();
}

class _TypeAheadState extends State<TypeAhead> {
  String _selectedSuggestion = '';
  final TextEditingController _typeAheadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightBlue,
                width: 2.0,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        suggestionsCallback: (pattern) async {
          if(pattern == '') {
            return [];
          }
          return await BackendService.search(pattern);
        }, 
        itemBuilder: (context, suggestion) {
          var item = suggestion['_source'];
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.person, size: 14.0,),
              title: Text(item['displayName']),
            )
          );
        },
        onSuggestionSelected: (suggestion) {
          var item = suggestion['_source'];
          this._typeAheadController.text = item['id'];
        },
        noItemsFoundBuilder: (context) {
          return Text('No Items Found');
        },
        loadingBuilder: (context) {
          return Container(
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            height: 100,
            child: Center(child: CircularProgressIndicator())
          );
        },
        errorBuilder: (context, error) {
          return Text('Error: $error');
        },
        onSaved: (value) {
          print('Saved Value: $value');
        },
      ),
    );
  }
}
