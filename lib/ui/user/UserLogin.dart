import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyHelperActivity.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/dashboard/Dashboard.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/UserRegister.dart';
import 'package:pontianak_smartcity/ui/user/UserResetPassword.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';
import 'package:toast/toast.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  //--- var ---
  final widgetGridMenu = LayoutLoading();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    //--- widget ---
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset('assets/icon/logo_landscape.png'),
      ),
    );

    FocusNode myFocusNodeEmail = new FocusNode();

    final email = TextFormField(
      focusNode: myFocusNodeEmail,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
            color: myFocusNodeEmail.hasFocus ? Colors.blue : Colors.grey),
        //hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.person,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    FocusNode myFocusNodePassword = new FocusNode();

    final password = TextFormField(
      focusNode: myFocusNodePassword,
      controller: _passwordController,
      autofocus: false,
      //initialValue: 'some password',
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Kata Sandi',
        labelStyle: TextStyle(
            color: myFocusNodePassword.hasFocus ? Colors.blue : Colors.grey),
        //hintText: 'Kata Sandi',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.lock,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 13.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(18),
          ),
        ),
        onPressed: () {
          if (_emailController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            MyHelper.toast(
              context,
              MyString.dataCannotEmpty,
            );
          } else {
            _login();
          }
        },
        // padding: EdgeInsets.all(12),
        // color: Colors.lightBlueAccent,
        child: Text('Masuk', style: TextStyle(color: Colors.white)),
      ),
    );

    final loading = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );

    final registerLabel = Center(
      child: new RichText(
        text: new TextSpan(
          style: TextStyle(
            fontSize: 20.0,
            height: 2,
          ),
          children: [
            new TextSpan(
              text: 'Belum punya akun? ',
              style: new TextStyle(color: Colors.black),
            ),
            new TextSpan(
              text: 'daftar disini',
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserRegister()),
                  );
                },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 3.0,
      //   title: Text("Login"),
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          children: <Widget>[
            logo,
            SizedBox(height: 50.0),
            email,
            SizedBox(height: 15.0),
            password,
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewWebView(
                                title: 'Kebijakan Privasi',
                                url:
                                    'https://jepin.pontianak.go.id/p/5-kebijakan-privasi',
                                breadcrumbs: 'Kebijakan Privasi',
                              )),
                    );
                  },
                  child: Text(
                    'Tentang Kebijakan Privasi',
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserResetPassword()),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => NewWebView(
                    //             title: 'Reset Kata Sandi',
                    //             url: 'https://jepin.pontianak.go.id/forgot-password',
                    //             breadcrumbs: 'Reset Kata Sandi',
                    //           )),
                    // );
                  },
                  child: Text('Reset Kata Sandi',
                      style: TextStyle(fontSize: 13, color: Colors.blue),
                      textAlign: TextAlign.right),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            _isLoading ? loading : loginButton,
            registerLabel
          ],
        ),
      ),
    );
  }

  Future<String> _login() async {
    setState(() {
      _isLoading = true;
    });

    String _bearerToken;
    String _idUser;
    String _email = _emailController.text;

    var map = new Map<String, dynamic>();
    map["email"] = _email;
    map["password"] = _passwordController.text;

    var response = await http.post(Uri.parse(ApiService.userLogin),
        headers: {"Accept": "application/json"}, body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _bearerToken = "Bearer " + result["data"]["token"];
        _idUser = result["data"]["id"].toString();

        MyHelperActivity.saveToken(_bearerToken, _idUser, _email);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false);
        MyHelper.toast(context, MyString.loginSuccess, gravity: Toast.center);
        // MyHelperActivity.checkToken();
      } else {
        MyHelper.toast(context, MyString.usernameIncorrect,
            gravity: Toast.center);
      }
    } else {
      MyHelper.toast(context, MyString.usernameIncorrect,
          gravity: Toast.center);
    }

    setState(() {
      _isLoading = false;
    });

    return "Success!";
  }
}
