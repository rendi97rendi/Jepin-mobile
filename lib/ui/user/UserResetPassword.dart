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
import 'package:pontianak_smartcity/master_layout/widgets/TextHeaderForPas.dart';
import 'package:pontianak_smartcity/master_layout/widgets/buttonForgetPassword.dart';
import 'package:pontianak_smartcity/master_layout/widgets/textDeskripsiForPas.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/UserResetPasswordCode.dart';
import 'package:toast/toast.dart';

class UserResetPassword extends StatefulWidget {
  @override
  _UserResetPasswordState createState() => _UserResetPasswordState();
}

class _UserResetPasswordState extends State<UserResetPassword> {
  final _emailController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final String text = _emailController.text.toLowerCase();
    _emailController.value = _emailController.value.copyWith(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
        composing: TextRange.empty);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
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
          'Lupa Password'.toUpperCase(),
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
                    header: "Masukkan Email disini",
                  ),
                  TextDeskripsiForgetPassword(
                    deskripsi:
                        'Masukkan Email yang sudah anda daftarkan. \n Kode untuk mengatur ulang kata sandi akan kami kirimkan di email anda.',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputEmail(emailController: _emailController),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonForgetPassword(
                    label: "Kirim Kode",
                    aksi: () {
                      if (_emailController.text.isEmpty) {
                        MyHelper.toast(
                          context,
                          MyString.emailEmpty,
                        );
                      } else {
                        _sendEmail();
                      }
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

  Future<String> _sendEmail() async {
    setState(() {
      _isLoading = true;
    });

    String _email = _emailController.text;

    var map = new Map<String, dynamic>();
    map["email"] = _email;

    var response = await http.post(
      Uri.parse(ApiService.sendEmail),
      headers: {"Accept": "application/json"},
      body: map,
    );

    var result = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (result["status"] == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserResetPasswordCode(email: _email)),
        );
      } else {
        MyHelper.toast(context, MyString.errorOther, gravity: Toast.center);
      }
    } else {
      MyHelper.toast(context, MyString.emailEmpty, gravity: Toast.center);
    }

    setState(() {
      _isLoading = false;
    });

    return "Success!";
  }
}
