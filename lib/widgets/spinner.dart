import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final Color? color;

  const Spinner({
    super.key,
    this.radius=20,
    this.strokeWidth=2,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final spinnerColor = color ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
      ),
    );
  }
}
