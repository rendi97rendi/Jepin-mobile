import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputEmail extends StatelessWidget {
  const InputEmail({
    Key? key,
    required TextEditingController emailController,
    this.label = "Email",
    this.placeholder = "example@email.com",
  }) : _emailController = emailController, super(key: key);

  final TextEditingController _emailController;
  final String label;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey[400]),
          fillColor: Colors.blue,
          prefixIcon: Icon(
            CupertinoIcons.envelope,
            color: Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}