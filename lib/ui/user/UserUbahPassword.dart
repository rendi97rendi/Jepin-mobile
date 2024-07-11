import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/master_layout/widgets/InputEmail.dart';
import 'package:pontianak_smartcity/master_layout/widgets/InputPassword.dart';
import 'package:pontianak_smartcity/master_layout/widgets/TextHeaderForPas.dart';
import 'package:pontianak_smartcity/master_layout/widgets/buttonForgetPassword.dart';
import 'package:pontianak_smartcity/master_layout/widgets/textDeskripsiForPas.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:toast/toast.dart';

class UserUbahPassword extends StatefulWidget {
  final String email;
  final String? title;

  UserUbahPassword({required this.email, this.title}) : super();
  @override
  _UserUbahPasswordState createState() => _UserUbahPasswordState();
}

class _UserUbahPasswordState extends State<UserUbahPassword> {
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ! Main Code
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.colorAppbar,
        centerTitle: true,
        elevation: 3.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          onPressed: () => {
            if (context.mounted) {Navigator.of(context).pop()}
          },
        ),
        title: Text(
          widget.title ?? 'Lupa Password'.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: MyFontSize.large,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? LayoutLoading() // Tampilkan indicator saat loading
            : Column(
          children: [
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 3,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                children: [
                  TextHeaderForgerPassword(
                    header: "Masukkan Password Baru",
                  ),
                  TextDeskripsiForgetPassword(
                    deskripsi:
                        'Password baru harus berbeda dari password yang lama',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputPassword(
                    controller: _passwordController,
                    label: "Password Baru",
                    placeholder: "Password Baru",
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputPassword(
                    controller: _konfirmasiPasswordController,
                    label: "Konfirmasi Password",
                    placeholder: "Konfirmasi Password",
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ButtonForgetPassword(
                    label: "Ubah Password",
                    aksi: () {
                      _sendPassword();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String _password = _passwordController.text;
      String _confirm_password = _konfirmasiPasswordController.text;

      var map = new Map<String, dynamic>();
      map["email"]                  = widget.email;
      map["password"]               = _password;
      map["password_confirmation"]  = _confirm_password;

      var response = await http.post(
        Uri.parse(ApiService.updatePassword),
        headers: {"Accept": "application/json"},
        body: map,
      );

      var result = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result["status"] == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLogin()),
          );
        } else {
          MyHelper.toast(context, "Gagal Mengubah Password", gravity: Toast.center);
        }
      } else {
        MyHelper.toast(context, "${result['message']}", gravity: Toast.center, timeDuration: 5);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print('Error loading code: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
