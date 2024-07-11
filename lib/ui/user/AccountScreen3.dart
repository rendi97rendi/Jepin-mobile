import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelperActivity.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/FeedbackScreen.dart';
import 'package:pontianak_smartcity/ui/user/FeedbackScreenUpdate.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:pontianak_smartcity/ui/user/UserProfile.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen3 extends StatefulWidget {
  final Function callbackSelectDash;
  const AccountScreen3(this.callbackSelectDash, {Key? key}) : super(key: key);

  @override
  State<AccountScreen3> createState() => _AccountScreen3State();
}

class _AccountScreen3State extends State<AccountScreen3> {
  bool _auth = false;
  bool _loadingLayout = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
      _loadingLayout = true;
      _auth = await MyHelperActivity.checkAuthToken();
      _loadingLayout = false;
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {

    Widget _loginWidget() {
      return  UserLogin();
    }

    Widget _AccontWidget() {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                SizedBox(width: 4.0),
                Text(
                  'AKUN ',
                  style: TextStyle(
                      fontSize: MyFontSize.large,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            )),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Ubah Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfile(this.widget.callbackSelectDash)),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Kritik dan Saran'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Kebijakan Aplikasi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewWebView(
                              title: 'Kebijakan Aplikasi',
                              url:
                                  'http://jepin.pontianak.go.id/p/5-kebijakan-privasi',
                              breadcrumbs: 'Kebijakan Aplikasi',
                            )),
                  );
                },
              ),
              // hapus account
              Divider(),

              ListTile(
                title: Text('Hapus Akun'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text("Anda yakin untuk menghapus Akun?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var userId = prefs.getString(MyConstanta.userId);
                              print('user id adalah $userId');
                              if (userId != null) {
                                var response = await http.delete(
                                  Uri.parse(ApiService.userDeleteProfile),
                                  headers: {
                                    "Accept": "application/json",
                                    "Authorization":
                                        prefs.getString(MyConstanta.saveToken) ??
                                            '',
                                  },
                                  body: {"id": userId},
                                );

                                if (response.statusCode == 200) {
                                  MyHelperActivity.deleteToken();
                                  Navigator.of(context).pop();
                                  widget.callbackSelectDash(0);

                                  // Menampilkan pesan sukses
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Sukses"),
                                        content: Text("Akun berhasil dihapus."),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                            "Gagal menghapus akun. Silakan coba lagi."),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                // Handle the case where userId is null
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              Divider(),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text("Anda yakin akan keluar?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              MyHelperActivity.deleteToken();
                              Navigator.of(context).pop();
                              widget.callbackSelectDash(0);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return _loadingLayout ? LayoutLoading() : (_auth ? _AccontWidget() : _loginWidget());

  }
}
