import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelperActivity.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/FeedbackScreen.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:pontianak_smartcity/ui/user/UserProfile.dart';
import 'package:pontianak_smartcity/ui/user/UserUbahPassword.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  final Function callbackSelectDash;
  const AccountScreen(this.callbackSelectDash, {Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
    setState(() {});
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(MyConstanta.email) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Widget _loginWidget() {
      return UserLogin();
    }

    final VoidCallback logoutAction = () {
      showDialog(
        context: context,
        builder: (_) {
          // return object of type Dialog
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Konfirmasi".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.blue,
                ),
              ],
            ),
            titleTextStyle: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            content: Text(
              "Apakah Anda yakin ingin keluar aplikasi?",
              textAlign: TextAlign.left,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              TextButton(
                child: Text("Tidak", style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("YA, Keluar"),
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
    };

    final VoidCallback hapusAkunAction = () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Konfirmasi".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.blue,
                ),
              ],
            ),
            titleTextStyle: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            content: Text(
              "Apakah Anda yakin untuk menghapus Akun JePin?",
              textAlign: TextAlign.left,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Batal",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("YA, Hapus"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  var userId = prefs.getString(MyConstanta.userId);
                  // print('user id adalah $userId');
                  if (userId != null) {
                    var response = await http.delete(
                      Uri.parse(ApiService.userDeleteProfile),
                      headers: {
                        "Accept": "application/json",
                        "Authorization":
                            prefs.getString(MyConstanta.saveToken) ?? '',
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
    };

    return _loadingLayout
        ? LayoutLoading()
        : (_auth
            ? Scaffold(
                appBar: AppBar(
                  elevation: 3.0,
                  backgroundColor: Color(0xFFFF9800),
                  leading: Icon(Icons.settings_rounded, color: Colors.white),
                  title: Text(
                    'PENGATURAN',
                    style: TextStyle(
                        fontSize: MyFontSize.large,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // height: 50,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _widgetMenu(
                                title: "Ubah Profile",
                                icon: Icons.person,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                            this.widget.callbackSelectDash)),
                                  );
                                },
                              ),
                              Divider(),
                              _widgetMenu(
                                title: "Ubah Password",
                                icon: Icons.lock_person_outlined,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserUbahPassword(
                                            email: _getEmail().toString(),
                                            title:
                                                'Ubah Password'.toUpperCase())),
                                  );
                                },
                              ),
                              Divider(),
                              _widgetMenu(
                                title: 'Umpan Balik',
                                icon: Icons.feedback_outlined,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FeedbackScreen()),
                                  );
                                },
                              ),
                              Divider(),
                              _widgetMenu(
                                title: 'Kebijakan Aplikasi',
                                icon: Icons.handyman_outlined,
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewWebView(
                                              title: 'Kebijakan Aplikasi',
                                              url: ApiService.kebijakanPrivasi,
                                              breadcrumbs: 'Kebijakan Aplikasi',
                                            )),
                                  );
                                },
                              ),
                              Divider(),
                              _widgetMenu(
                                title: 'Hapus Akun',
                                icon: Icons.delete_forever_outlined,
                                color: Colors.redAccent,
                                action: hapusAkunAction,
                              ),
                              Divider(),
                              _widgetMenu(
                                title: 'Logout',
                                icon: Icons.logout_outlined,
                                color: Colors.black,
                                action: logoutAction,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : _loginWidget());
  }
}

class _widgetMenu extends StatelessWidget {
  const _widgetMenu({
    Key? key,
    this.title,
    this.icon = Icons.abc,
    this.color = Colors.blueAccent,
    this.fontColor,
    this.action,
  }) : super(key: key);

  final String? title;
  final IconData icon;
  final Color color;
  final Color? fontColor;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200], // Background color of the circle
        child: Icon(this.icon, color: this.color), // Icon inside the circle
      ),
      title: Text(
        this.title ?? '',
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: this.fontColor ?? this.color),
      ),
      onTap: this.action,
    );
  }
}
