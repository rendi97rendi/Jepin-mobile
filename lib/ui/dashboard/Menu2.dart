import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';

List _dataList = [];

class Menu2 extends StatefulWidget {
  final List dataList;
  final String breadcrumbs;
  Menu2({Key? key, required this.dataList, required this.breadcrumbs})
      : super(key: key);

  @override
  _Menu2State createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {
  @override
  void initState() {
    _dataList = this.widget.dataList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        title: Text(MyString.appName),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Container(
              color: MyHelper.hexToColor(MyColor.greySoft),
              height: 40.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Center(
                    child: Text(
                      this.widget.breadcrumbs,
                      style: TextStyle(fontSize: MyFontSize.medium),
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _dataList == null ? 0 : _dataList.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //   RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(18.0),
                //     side: BorderSide(color: Colors.red),
                //   ),
                // ),
                // splashColor: Colors.indigo[100],
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.indigo[100]!),
                elevation: MaterialStateProperty.all<double>(1.0),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8.0)),
              ),
              // splashColor: Colors.indigo[100],
              // elevation: 1.0,
              // color: Colors.white,
              // padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.arrow_right),
                    Expanded(
                      child: Text(
                        _dataList[index]["label"],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                _clickMenu(index);
              },
            );
          },
        ),
      ),
    );
  }

  void _clickMenu(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewWebView(
              title: _dataList[index]["label"],
              url: _dataList[index]["link"],
              breadcrumbs:
                  this.widget.breadcrumbs + " > " + _dataList[index]["label"])),
    );
  }
}
