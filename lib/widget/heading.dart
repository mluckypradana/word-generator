import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;

  const Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
