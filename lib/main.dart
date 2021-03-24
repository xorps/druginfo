import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'state_machine.dart';

void main() => runApp(App());

mixin SearchField on FsmState {
  void onSubmitted(String text) async {
    setState(Loading());
    try {
      final url = Uri.parse('https://api.fda.gov/drug/label.json?search=openfda.product_ndc:"$text"&limit=1');
      final result = await http.get(url);
      final txt = result.body;
      final json = jsonDecode(txt);
      if (json is Map && json["error"] is Map && json["error"]["message"] is String) {
        setState(ApiErrorMessage(json["error"]["message"]));
      } else if (json is Map && json["results"] is List) {
        final results = json["results"] as List<dynamic>;
        if (results.length > 0 && results.first is Map) {
          setState(Ready(results.first));
        } else {
          setState(EmptyResults());
        }
      }
    } catch (err) {
      setState(CaughtError(err));
    }
  }

  Widget searchField() => CupertinoSearchTextField(placeholder: 'Product NDC', onSubmitted: onSubmitted);
}

class Idle extends FsmState with SearchField {
  @override
  Widget render() => searchField();
}

class Loading extends FsmState {
  @override
  Widget render() => CupertinoActivityIndicator();
}

class Drug {
  final String name;
  Drug({required this.name});
}

class Ready extends FsmState with SearchField {
  final Map _result;

  Ready(this._result);

  static Widget _renderEntry(MapEntry<dynamic, dynamic> entry) {
    final key = Text(entry.key);
    final value = Text(entry.value);
    final decoration = BoxDecoration(color: CupertinoColors.extraLightBackgroundGray, borderRadius: BorderRadius.circular(10));
    return Container(margin: EdgeInsets.symmetric(vertical: 10), padding: EdgeInsets.all(10), decoration: decoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [key, value]));
  }

  Widget _renderResult() {
    final children = _result.entries.where((entry) => entry.value is String).map(_renderEntry).toList();
    return ListView(
      children: children,
      primary: false
    );
  }

  @override
  Widget render() => Column(children: [searchField(), Expanded(child: _renderResult())]);
}

class ApiErrorMessage extends FsmState with SearchField {
  final String _message;

  ApiErrorMessage(this._message);

  @override
  Widget render() => Column(children: [searchField(), Text(_message)]);
}

class CaughtError extends FsmState with SearchField {
  final dynamic _err;

  CaughtError(this._err);

  @override
  Widget render() => Column(children: [searchField(), Text("Error: $_err")]);
}

class EmptyResults extends FsmState with SearchField {
  @override
  Widget render() => Column(children: [searchField(), Text("No Results")]);
}

class SearchBar extends StateMachineWidget {
  @override
  initialState() => Idle();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return CupertinoApp(
      title: 'Flutter Demo', 
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Drug Info')),
      child: SafeArea(minimum: EdgeInsets.symmetric(vertical: 100, horizontal: 20), child: SearchBar()),
    );
  }
}
