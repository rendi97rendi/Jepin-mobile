import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollToTop extends StatelessWidget {
  final VoidCallback actionPress;

  const ScrollToTop({
    Key? key,
    this.actionPress = _defaultOnPressed,
  }) : super(key: key);

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      right: 25.0,
      child: FittedBox(
        child: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.amber,
          splashColor: Colors.orange[400],
          onPressed: actionPress,
          tooltip: 'Scroll ke Atas',
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
          // elevation: 5.0,
        ),
      ),
    );
  }
}
