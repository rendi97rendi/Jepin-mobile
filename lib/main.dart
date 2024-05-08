import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/Splash.dart';
import 'package:pontianak_smartcity/ui/dashboard/Menu.dart';

void main() {
  initializeDateFormatting('id_ID', null);
  runApp(MaterialApp(
    title: MyString.appName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 239, 240, 252),
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange[300],
    ),
    home: Splash(),
    routes: <String, WidgetBuilder>{
      '/Menu': (BuildContext context) => Menu(title: 'MENU'),
    },
  ));
}
