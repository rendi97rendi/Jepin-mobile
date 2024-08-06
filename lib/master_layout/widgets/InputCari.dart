import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputCari extends StatelessWidget {
  const InputCari({
    Key? key,
    required TextEditingController searchController,
    this.label = "",
    this.placeholder = "Cari",
    this.actionPress = _defaultOnPressed,
    this.actionChange = _defaultOnChanged,
  })  : _searchController = searchController,
        super(key: key);

  final TextEditingController _searchController;
  final String label;
  final String? placeholder;
  final VoidCallback actionPress;
  final void Function(String) actionChange;

  static void _defaultOnPressed() {}
  static void _defaultOnChanged(String value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 7, right: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
        decoration: InputDecoration(
          hintText: label.isNotEmpty ? label : placeholder,
          hintStyle: TextStyle(color: Colors.black45),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          suffixIcon: IconButton(
            onPressed: actionPress,
            icon: Icon(Icons.clear),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: actionChange,
      ),
    );
  }
}
