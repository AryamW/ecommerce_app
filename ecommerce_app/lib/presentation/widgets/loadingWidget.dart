

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoadingWidget extends StatefulWidget {
  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  @override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

  _controller.forward();
}

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: 4.0, // Height of the line
          width: _animation.value * 200, // Width of the line based on animation value
          decoration: BoxDecoration(
            color: Colors.blue, // Color of the line
            borderRadius: BorderRadius.circular(2.0), // Optional: to make the line rounded
          ),
        );
      },
    );
  }
}