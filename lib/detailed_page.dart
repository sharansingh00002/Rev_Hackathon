import 'package:flutter/material.dart';

class DetailedPage extends StatelessWidget {
  final text;

  const DetailedPage({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hindi Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
