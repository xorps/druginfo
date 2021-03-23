import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() => runApp(App());

abstract class SearchStatus {
  T match<T>(T Function(Idle) caseIdle, T Function(Loading) caseLoading, T Function(Ready) caseReady);
}

class Idle extends SearchStatus {
  T match<T>(T Function(Idle) caseIdle, T Function(Loading) caseLoading, T Function(Ready) caseReady) => caseIdle(this);
}

class Loading extends SearchStatus {
  T match<T>(T Function(Idle) caseIdle, T Function(Loading) caseLoading, T Function(Ready) caseReady) => caseLoading(this);
}

class Ready extends SearchStatus {
  final String result;

  Ready(this.result);

  T match<T>(T Function(Idle) caseIdle, T Function(Loading) caseLoading, T Function(Ready) caseReady) => caseReady(this);
}

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  SearchStatus _status = Idle();

  void _onSubmitted(String text) async {
    setState(() {
      _status = Loading();
    });

    try {
      final url = Uri.parse('https://api.fda.gov/drug/label.json?search=openfda.product_ndc:"$text"');
      final result = await http.get(url);
      final txt = result.body;
      setState(() {
        _status = Ready(txt);
      });
    } catch (err) {
      setState(() {
        _status = Ready("Error: $err");
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return _status.match(
      (Idle _) => CupertinoSearchTextField(onSubmitted: _onSubmitted),
      (Loading _) => CupertinoActivityIndicator(), 
      (Ready r) => Column(children: [CupertinoSearchTextField(onSubmitted: _onSubmitted), Text(r.result)]),
    );
  }
}

class App extends StatelessWidget {
  @override
  build(ctx) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(title: 'Drug Info'));
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  build(ctx) => Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 20), child: SearchBar())
      ])));
}
