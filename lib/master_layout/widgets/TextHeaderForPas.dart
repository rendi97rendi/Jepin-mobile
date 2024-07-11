import 'package:flutter/material.dart';

class TextHeaderForgerPassword extends StatelessWidget {
  const TextHeaderForgerPassword({
    Key? key,
    this.header,
    this.warna,
    this.ukuranHuruf = 20.0,
  }) : super(key: key);

  final String? header;
  final Color? warna;
  final double ukuranHuruf;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          header ?? '',
          style: TextStyle(
              color: warna ?? Colors.orange,
              fontSize: ukuranHuruf,
              fontWeight: FontWeight.bold,
              height: 2),
        ),
      ),
    );
  }
}