import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(App());

class SearchBar extends StatefulWidget {
  createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override build(ctx) => CupertinoSearchTextField();
}

class App extends StatelessWidget {
  @override build(ctx) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(title: 'Drug Info')
    );
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  @override createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override build(ctx) => Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SafeArea(minimum: EdgeInsets.symmetric(horizontal: 20), child: SearchBar())]
        )
      )
    );
}
