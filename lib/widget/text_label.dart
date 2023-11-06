import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final EdgeInsets padding;

  const TextLabel({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
