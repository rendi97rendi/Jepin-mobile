import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/common/MyHelperActivity.dart';
import 'package:pontianak_smartcity/ui/dashboard/Apps.dart';
import 'package:pontianak_smartcity/ui/dashboard/home_screen.dart';
import 'package:pontianak_smartcity/ui/news/NewsList.dart';
import 'package:pontianak_smartcity/ui/user/AccountScreen.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:pontianak_smartcity/ui/webview/MyWebview.dart';
import 'Place.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color colorBar = Colors.indigo;
  int _selectedDashboard = 0;
  String _logoApps = ApiService.imagePlaceholder;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.bgColor,
      // floatingActionButton: _selectedDashboard == 0
      //     ? FloatingActionButton(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.chat_bubble,
      //               color: Colors.white,
      //               size: 26,
      //             ),
      //             Text(
      //               'Lapor\n.go.id',
      //               style: TextStyle(
      //                 fontSize: 8,
      //                 color: Colors.white
      //               ),
      //             )
      //           ],
      //         ),
      //         onPressed: () {
      //           Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => MyWebview(
      //                   title: 'Lapor',
      //                   url: 'https://www.lapor.go.id/',
      //                   breadcrumbs: 'Lapor',
      //                 )),
      //       );
      //         },
      //       )
      //     : null,
      body: Container(
        child: Builder(builder: (context) {
          switch (_selectedDashboard) {
            case 1:
              return Place();
            case 2:
              return News();
            case 3:
            //   return Apps();
            // case 4:
              return AccountScreen(this.callbackSelectDash);
            default:
              return HomeScreen(callback: this.callbackSelectDash);
          }
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: MyString.smartcity,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place, size: 30),
              label: MyString.place,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper, size: 30),
              label: MyString.news,
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.apps, size: 30),
            //   label: MyString.application,
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp, size: 30),
              label: MyString.account,
            ),
          ],
          currentIndex: _selectedDashboard,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey.withOpacity(0.8),
          showUnselectedLabels: true,
          onTap: _onTabDashboard,
        ),
      ),
    );
  }

  void callback(Color color) {
    setState(() {
      colorBar = color;
    });
  }

  void callbackLogoApps(String logo) {
    setState(() {
      _logoApps = logo;
    });
  }

  void callbackSelectDash(int index) {
    setState(() {
      _selectedDashboard = index;
    });
  }

  void _onTabDashboard(int index) {
    setState(() {
      // if (index == 4) {
      //   _auth(index);
      // } else {
      _selectedDashboard = index;
      // }
    });
  }

  void _auth(index) async {
    MyHelperActivity.auth(() {
      _selectedDashboard = index;
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserLogin()),
      );
    });
  }
}
