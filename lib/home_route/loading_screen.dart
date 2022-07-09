import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          /// Loader Animation Widget
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Text('Loading'),
        ],
      ),
    );
  }
}
