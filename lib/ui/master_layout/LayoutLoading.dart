import 'package:flutter/material.dart';

class LayoutLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(color: Colors.orange,),
      )
    );
  }
}