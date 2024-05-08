import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/master_layout/MyLayoutImage.dart';
import 'package:pontianak_smartcity/ui/application/ApplicationDetail.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:toast/toast.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  //--- variable ---
  var _loadingData = false;
  List _listData = [];

  @override
  void initState() {
    showData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widgetGridMenu = _loadingData
        ? LayoutLoading()
        : GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _listData == null ? 0 : _listData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _listData.length <= 6 ? 2 : 3,
              childAspectRatio: 1 / 0.6,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicationDetail(
                        name: _listData[index]["nama"],
                        urlPlaystore: _listData[index]["link_apps"],
                        urlWeb: _listData[index]["link_web"],
                        imagetypography: _listData[index]["typography"] == null
                            ? ApiService.baseUrl2 + _listData[index]["logo"]
                            : ApiService.baseUrl2 +
                                _listData[index]["typography"],
                        description: ApiService.baseUrl2 +
                            _listData[index]["keterangan"],
                        color: _listData[index]["warna"],
                      ),
                    ),
                  );
                },
                child: _ViewHolderApps(
                  id: _listData[index]["id"],
                  logo: _listData[index]["logo"],
                  name: _listData[index]["nama"],
                ),
              );
            });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.orange,
        leading: Icon(
          Icons.apps,
          color: Colors.white,
        ),
        title: Text(
          MyString.application.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          widgetGridMenu,
        ],
      ),
    );
  }

  //--- Method ---
  Future<String> showData() async {
    setState(() {
      _loadingData = true;
    });

    var response = await http.get(
      Uri.parse(ApiService.application),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);
      if (result["status"] == "success") {
        _listData = result["data"]["data"];
      } else {
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    setState(() {
      _loadingData = false;
    });

    return "Success!";
  }
}

class _ViewHolderApps extends StatelessWidget {
  final int id;
  final String name, logo;

  const _ViewHolderApps(
      {Key? key, required this.id, required this.name, required this.logo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            padding: EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: MyLayoutImage(
                  height: 100.0,
                  width: 100.0,
                  image: logo == null
                      ? ApiService.imagePlaceholder
                      : ApiService.baseUrl2 + logo,
                  fit: BoxFit.cover,
                )),
          ),
          Text(
            MyHelper.returnToString(name),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
