import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/master_layout/widgets/TextHeaderForPas.dart';
import 'package:pontianak_smartcity/master_layout/widgets/textDeskripsiForPas.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/UserUbahPassword.dart';
import 'package:toast/toast.dart';

class UserResetPasswordCode extends StatefulWidget {
  final String email;

  UserResetPasswordCode({required this.email}) : super();
  @override
  _UserResetPasswordCodeState createState() => _UserResetPasswordCodeState();
}

class _UserResetPasswordCodeState extends State<UserResetPasswordCode> {
  final _kodeController = TextEditingController();
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  String? currentCode; // Kode dari API
  bool _isLoading = false;
  bool _isLoadingCode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeFromAPI();

    final String text = _kodeController.text.toLowerCase();
    _kodeController.value = _kodeController.value.copyWith(
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
    _kodeController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  Future<void> getCodeFromAPI() async {
    setState(() {
      _isLoadingCode = true;
    });
    try {
      final response =
          await http.get(Uri.parse(ApiService.getCode + "/" + widget.email));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          currentCode = jsonResponse['data'].toString();
          _isLoadingCode = false;
        });
      } else {
        // print('Failed to load code: ${response.statusCode}');
        setState(() {
          _isLoadingCode = false;
        });
      }
    } catch (e) {
      // print('Error loading code: $e');
      setState(() {
        _isLoadingCode = false;
      });
    }
  }

  Future<bool> _resendCode() async {
    setState(() {
      _isLoadingCode = true;
    });
    bool _status = false;
    String _email = widget.email;

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
        _status = true;
        getCodeFromAPI();
      }
    }
    setState(() {
      _isLoadingCode = false;
    });
    return _status;
  }

  bool isCodeComplete() {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void handleVerification() async {
    if (isCodeComplete()) {
      // Lakukan aksi verifikasi atau tampilkan pesan
      String pin = '';
      for (var controller in controllers) {
        pin += controller.text;
      }
      print(pin);
      // Contoh: Validasi PIN dan navigasi ke layar berikutnya
      if (pin == currentCode.toString()) {
        // PIN benar, lakukan navigasi ke layar berikutnya
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserUbahPassword(
              email: widget.email,
            ),
          ),
        );
      } else {
        // PIN salah, tampilkan pesan kesalahan atau atur ulang PIN
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN Salah.'),
            backgroundColor: Colors.red,
            elevation: 3,
            showCloseIcon: true,
          ),
        );
      }
    }
    // else {
    //   // Tampilkan pesan bahwa semua kode harus diisi
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Harap masukkan semua kode terlebih dahulu.'),
    //     ),
    //   );
    // }
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
                          header: "Masukkan Kode",
                        ),
                        TextDeskripsiForgetPassword(
                          deskripsi:
                              "Masukkan Kode 4 angka yang dikirim ke email anda.",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              PinBox(
                                controller: controllers[0],
                                focusNode: focusNodes[0],
                                nextFocusNode:
                                    focusNodes[1], // Fokus berikutnya
                                onChanged: (_) => handleVerification(),
                              ),
                              PinBox(
                                controller: controllers[1],
                                focusNode: focusNodes[1],
                                nextFocusNode:
                                    focusNodes[2], // Fokus berikutnya
                                onChanged: (_) => handleVerification(),
                              ),
                              PinBox(
                                controller: controllers[2],
                                focusNode: focusNodes[2],
                                nextFocusNode:
                                    focusNodes[3], // Fokus berikutnya
                                onChanged: (_) => handleVerification(),
                              ),
                              PinBox(
                                controller: controllers[3],
                                focusNode: focusNodes[3],
                                onChanged: (_) => handleVerification(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Belum menerima Kode? "),
                              _isLoadingCode
                                  ? LayoutLoading()
                                  : GestureDetector(
                                      onTap: () async {
                                        if (await _resendCode() == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Kode sudah dikirim ulang ke email anda.',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              backgroundColor: Colors.blue,
                                              elevation: 3,
                                              showCloseIcon: true,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Kode gagal dikirim, silahkan coba lagi..',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                              elevation: 3,
                                              showCloseIcon: true,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Kirim Ulang Kode',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Theme.of(context).primaryColor,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.orange,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // ButtonForgetPassword(
                        //   label: "Verifikasi Kode",
                        //   aksi: () {},
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class PinBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onChanged;

  PinBox({
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly, // Hanya menerima angka
          ],
          maxLength: 1,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            onChanged?.call(value);
            controller.value = TextEditingValue(
                text: value,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: value.length), // move cursor to end
                ),
              );

            if (value.isNotEmpty && nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ),
    );
  }
}
