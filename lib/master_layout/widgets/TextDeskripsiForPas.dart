import 'package:flutter/material.dart';

class TextDeskripsiForgetPassword extends StatelessWidget {
  const TextDeskripsiForgetPassword({
    Key? key,
    this.deskripsi,
    this.warna,
    this.ukuranHuruf = 12.0,
  }) : super(key: key);

  final String? deskripsi;
  final Color? warna;
  final double ukuranHuruf;
  @override
  Widget build(BuildContext context) {
    return Text(
      deskripsi ?? '',
      textAlign: TextAlign.center,
      softWrap: true,
      style: TextStyle(
        color: warna ?? Colors.grey[500],
        fontSize: ukuranHuruf,
      ),
    );
  }
}