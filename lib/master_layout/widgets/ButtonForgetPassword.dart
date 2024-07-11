import 'package:flutter/material.dart';

class ButtonForgetPassword extends StatelessWidget {
  const ButtonForgetPassword({
    Key? key,
    this.label = "Kirim Kode",
    this.aksi,
  }) : super(key: key);

  final String label;
  final VoidCallback? aksi;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: aksi,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 15.0),
      ),
      style: ButtonStyle(
          elevation: WidgetStatePropertyAll(3.0),
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }
}