import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/AccountScreen.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  //--- var ---
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isAgree = false;
  var _isLoading = false;
  var _passwordVisible = false;
  var _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNodeName = new FocusNode();
    FocusNode myFocusNodeUsername = new FocusNode();
    FocusNode myFocusNodeEmail = new FocusNode();
    FocusNode myFocusNodePassword = new FocusNode();
    FocusNode myFocusNodeConfirmPassword = new FocusNode();
    FocusNode myFocusNodePhone = new FocusNode();

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: Image.asset('assets/icon/icon.png'),
      ),
    );

    final fullName = TextFormField(
      focusNode: myFocusNodeName,
      controller: _fullNameController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        labelStyle: TextStyle(
            color: myFocusNodeName.hasFocus ? Colors.blue : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.person_crop_square,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final username = TextFormField(
      focusNode: myFocusNodeUsername,
      controller: _usernameController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
            color: myFocusNodeUsername.hasFocus ? Colors.blue : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.person,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final email = TextFormField(
      focusNode: myFocusNodeEmail,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
            color: myFocusNodeEmail.hasFocus ? Colors.blue : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.mail,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final password = TextFormField(
      focusNode: myFocusNodePassword,
      controller: _passwordController,
      autofocus: false,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Kata Sandi',
        labelStyle: TextStyle(
            color: myFocusNodePassword.hasFocus ? Colors.blue : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.lock,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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

    final cPassword = TextFormField(
      focusNode: myFocusNodeConfirmPassword,
      controller: _cpasswordController,
      autofocus: false,
      obscureText: !_confirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Konfirmasi Kata Sandi',
        labelStyle: TextStyle(
            color: myFocusNodeConfirmPassword.hasFocus
                ? Colors.blue
                : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.lock_rotation,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _confirmPasswordVisible = !_confirmPasswordVisible;
            });
          },
        ),
      ),
    );

    final phone = TextFormField(
      focusNode: myFocusNodePhone,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Nomor HP',
        labelStyle: TextStyle(
            color: myFocusNodePhone.hasFocus ? Colors.blue : Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 0), // add padding to adjust icon
          child: Icon(
            CupertinoIcons.phone,
            color: Colors.grey,
            size: 24.0,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(18),
          ),
        ),
        onPressed: () {
          _register();
        },
        child: Text('Daftar', style: TextStyle(color: Colors.white)),
      ),
    );

    final loginLabel = Center(
      child: new RichText(
        text: new TextSpan(
          style: TextStyle(
            fontSize: 20.0,
            height: 2,
          ),
          children: [
            new TextSpan(
              text: 'Sudah punya akun? ',
              style: new TextStyle(color: Colors.black),
            ),
            new TextSpan(
              text: 'login disini',
              style: new TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context, false);
                },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: MyColor.colorAppbar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          MyString.register.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.minimize),
            color: Colors.orange,
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          children: <Widget>[
            logo,
            SizedBox(height: 20.0),
            fullName,
            SizedBox(height: 10.0),
            username,
            SizedBox(height: 10.0),
            email,
            SizedBox(height: 10.0),
            phone,
            SizedBox(height: 10.0),
            password,
            SizedBox(height: 10.0),
            cPassword,
            SizedBox(height: 10.0),
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: isAgree,
                      activeColor: Colors.orange,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isAgree = newValue ?? isAgree;
                        });
                      }),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Membuat akun berarti anda menyetujui tentang ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(color: Colors.orange),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://jepin.pontianak.go.id/p/5-kebijakan-privasi');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            registerButton,
            SizedBox(height: 10.0),
            loginLabel,
          ],
        ),
      ),
    );
  }

  Future<String> _register() async {
    String _bearerToken;
    String _idUser;

    var map = new Map<String, dynamic>();
    map["name"] = _fullNameController.text;
    map["username"] = _usernameController.text;
    map["email"] = _emailController.text;
    map["password"] = _passwordController.text;
    map["c_password"] = _cpasswordController.text;

    if (!isEmailValid(map['email'])) {
      MyHelper.toast(context, 'Email yang anda masukkan tidak valid',
          gravity: Toast.center);
      return 'Error!';
    }

    if (!isAgree) {
      MyHelper.toast(context,
          'Mohon untuk menyetujui kebijakan privasi sebagai syarat mendaftar di aplikasi ini',
          gravity: Toast.center);
      return 'Error!';
    }

    setState(() {
      _isLoading = true;
    });

    // print(ApiService.userRegister);
    var response = await http.post(Uri.parse(ApiService.userRegister),
        headers: {"Accept": "application/json"}, body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        Navigator.pop(context);
        MyHelper.toast(context, MyHelper.returnToString(result["message"]),
            gravity: Toast.center);
      } else {
        MyHelper.toast(context, MyString.msgError, gravity: Toast.center);
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

  bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
