import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;

  InputPassword({this.controller, this.label, this.placeholder});
  
  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _isObscure = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextField(
        obscureText: _isObscure,
        controller: widget.controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          hintText: widget.placeholder,
          hintStyle: TextStyle(color: Colors.grey[400]),
          fillColor: Colors.blue,
          prefixIcon: Icon(
            CupertinoIcons.lock_shield,
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