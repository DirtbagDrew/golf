import 'package:flutter/material.dart';
import 'package:golf_project/widgets/VideoSelectorRadial.dart';
import 'VideoPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open video selector'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoPage()),
            );
          },
        ),
      ),
    );
  }
}
