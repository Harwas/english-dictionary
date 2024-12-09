import 'package:flutter/material.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
    // TODO: implement ==
    State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  @override
    // TODO: implement ==
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
      ),
    );
  }
}