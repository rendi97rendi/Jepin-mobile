import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyConstanta.dart';

class MyHelperActivity {
   
  // _prefProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //int counter = (prefs.getInt('counter') ?? 0) + 1;
  //   //print('Pressed $counter times.');
  //   await prefs.setString("userUsername", _usernameController.text);

  //   // prefs.clear();

  //   print("Hasilnya : " + (prefs.getString("userUsername") == null ? "Kosong" : prefs.getString("userUsername")) );
  // }

  //--- User ---

  static saveToken(String bearerToken, String idUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyConstanta.saveToken, bearerToken);
    await prefs.setString(MyConstanta.userId, idUser);
  }

  static checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString(MyConstanta.saveToken));
  }

  static deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool>checkAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(MyConstanta.saveToken) == null) {
      return false;
    } else {
      return true;
    }
  }

  static auth(void success(), void error()) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkToken();
    if (prefs.getString(MyConstanta.saveToken) == null) {
      error();
    } else {
      success();
    }
  }

  //--- Layout ---

//  static showDialog(String title, String content, void ok(), void close()) {
//    return
//  }

  static showDialog(BuildContext context, String title, String content, void ok(), void close()) {
//    AlertDialog(
//      title: Text(title),
//      content: Text(content),
//      actions: <Widget>[
//        FlatButton(
//          child: new Text("OK"),
//          onPressed: () {
//
//          },
//        ),
//        FlatButton(
//          child: new Text("Close"),
//          onPressed: () {
//
//          },
//        ),
//      ],
//    );
  }

}