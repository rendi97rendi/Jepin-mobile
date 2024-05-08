import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/food_info/FoodInfo.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';

import 'Menu2.dart';

String _title = "";
List? _data, _dataList;

class Menu extends StatefulWidget {
  final String? title;
  final List? data;
  final List? dataList;
  Menu({Key? key, this.title, this.data, this.dataList}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    setState(() {
      _title = this.widget.title ?? '';
      _data = this.widget.data;
      _dataList = this.widget.dataList;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hrzMenu = Container(
      margin: EdgeInsets.only(top: 4.0),
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _data == null ? 0 : _data?.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _clickMenuHorizontal(index);
            },
            child: MenuUtamaItem(
              title: _data?[index]["menu"]["label"],
              icon: MyHelper.replaceBaseUrl(
                  _data?[index]["menu"]["android_icon"]),
            ),
          );
        },
      ),
    );

    final _titleMenu = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
      child: Text(
        _title,
        style:
            TextStyle(fontSize: MyFontSize.large, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        title: Text(MyString.appName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _hrzMenu,
          _titleMenu,
          //--- Menu List Vertical ---
          Expanded(
            child: ListView.builder(
              itemCount: _dataList == null ? 0 : _dataList?.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //   RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(18.0),
                    //     side: BorderSide(color: Colors.red),
                    //   ),
                    // ),
                    // splashColor: Colors.indigo[100],
                    elevation: MaterialStateProperty.all<double>(1.0),
                    // padding: MaterialStateProperty.all<EdgeInsets>(
                    //     EdgeInsets.all(0.0)),
                  ),
                  // elevation: 1.0,
                  // splashColor: Colors.indigo[100],
                  // color: Colors.white,
                  // padding: EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_right),
                        Text(
                          _dataList?[index]["menu"]["label"],
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _clickMenuVertical(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clickMenuHorizontal(int index) {
    setState(() {
      List menuHrz = _data?[index]["list"];

      if (menuHrz.length == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewWebView(
                    title: _data?[index]["menu"]["label"],
                    url: _data?[index]["menu"]["link"],
                    breadcrumbs: _data?[index]["menu"]["label"],
                  )),
        );
      } else {
        _title = _data?[index]["menu"]["label"];
        _dataList = _data?[index]["list"];
      }
    });
  }

  void _clickMenuVertical(int index) {
    if (_dataList?[index]["menu"]["id"] == 158) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodInfo(),
        ),
      );
    } else {
      List subMenu = _dataList?[index]["list"];

      if (subMenu.length == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewWebView(
                  title: _dataList?[index]["menu"]["label"],
                  url: _dataList?[index]["menu"]["link"],
                  breadcrumbs:
                      _title + " > " + _dataList?[index]["menu"]["label"])),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Menu2(
                  dataList: _dataList?[index]["list"],
                  breadcrumbs:
                      _title + " > " + _dataList?[index]["menu"]["label"])),
        );
      }
    }
  }
}

class MenuUtamaItem extends StatelessWidget {
  MenuUtamaItem({required this.title, required this.icon});
  final String title, icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Container(
        width: 80.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60.0,
              width: 60.0,
              child: Image.network(
                icon,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
