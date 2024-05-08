import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/ui/culinary/CulinaryList.dart';
import 'package:pontianak_smartcity/ui/hotel/HotelList.dart';
import 'package:pontianak_smartcity/ui/tourism/TourismList.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/event/EventDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List _menuTitle = ["Tempat Wisata", "Penginapan", "Kuliner", "Oleh - Oleh"];
List _menuIcon = [
  "assets/images/hex-travel.png",
  "assets/images/hex-hotel.png",
  "assets/images/hex-food.png",
  "assets/images/hex-souvenir.png",
];

class Place extends StatefulWidget {
  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  // --- variable ---
  List _listEvent = [];
  bool _loadingEvent = true;

  //--- method ---
  Future<String> showEvent() async {
    setState(() {
      _loadingEvent = true;
    });

    var response = await http.get(
      Uri.parse(ApiService.event),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        inspect(result['data']['data']);
        _listEvent = result["data"]['data'];

        setState(() {
          _loadingEvent = false;
        });
      } else {
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }

  void _openMenu(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TourismList(
                  title: _menuTitle[index],
                )),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HotelList(
                  title: _menuTitle[index],
                )),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CulinaryList(
                  title: _menuTitle[index],
                )),
      );
    } else if (index == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(canvasColor: Colors.orange),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: const Text(
                'Oleh - Oleh',
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'Tidak ada destinasi oleh-oleh yang terdaftar!',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    showEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _widgedListEvent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Divider(),
        (_listEvent.length == 0)
            ? Container()
            : Container(
                height: 160.0,
                child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _listEvent == null ? 0 : _listEvent.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_listEvent == null) {
                        return Container();
                      } else {
                        if (_listEvent[index]["gambar"] == null ||
                            _listEvent[index]["gambar"] == 'null' ||
                            _listEvent[index]["gambar"]?.isEmpty) {
                          _listEvent[index]["gambar"] =
                              ApiService.imagePlaceholder;
                        } else {
                          _listEvent[index]["gambar"] =
                              ApiService.baseUrl2 + _listEvent[index]["gambar"];
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetail(
                                        idEvent:
                                            _listEvent[index]["id"].toString(),
                                      )),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: Stack(children: <Widget>[
                              Container(
                                width: 240.0,
                                child: CachedNetworkImage(
                                  imageUrl: _listEvent[index]
                                      ["gambar"], //--- set value
                                  placeholder: (context, url) => Center(
                                      child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(),
                                  )),
                                  errorWidget: (context, url, error) => Center(
                                    // child: Icon(Icons.error),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiService
                                          .imagePlaceholder, //--- set value
                                      placeholder: (context, url) => Center(
                                          child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Icon(Icons.error),
                                      ),
                                      width: 240.0,
                                      height: 160.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: 240.0,
                                  height: 160.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        MyHelper.returnToString(
                                            _listEvent[index]
                                                ["nama"]), //--- set value
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MyFontSize.medium,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        MyHelper.formatShortDate(
                                                _listEvent[index]
                                                    ["tanggal_mulai"]) +
                                            " s/d " +
                                            MyHelper.formatShortDate(
                                                _listEvent[index]
                                                    ["tanggal_selesai"]),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MyFontSize.small,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4.0,
                                right: 4.0,
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                                    decoration: BoxDecoration(
                                        color: MyHelper.hexToColor("#4281f5"),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Center(
                                      child: Text(
                                        "Event",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MyFontSize.small),
                                      ),
                                    )),
                              )
                            ]),
                          ),
                        );
                      }
                    }),
              ),
      ],
    );

    final _widgetGridMenu = GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _menuTitle == null ? 0 : _menuTitle.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _menuTitle.length <= 6 ? 2 : 3,
          childAspectRatio: 1 / 0.6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _openMenu(index);
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: _ViewHolderDshMenu(index: index),
          );
        });

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.orange,
        leading: Icon(
          Icons.place,
          color: Colors.white,
        ),
        title: Text(
          MyString.place.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _widgedListEvent,
          SizedBox(
            height: 8.0,
          ),
          _widgetGridMenu
        ],
      ),
    );
  }
}

class _ViewHolderDshMenu extends StatelessWidget {
  final int index;
  const _ViewHolderDshMenu({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            height: 100.0,
            width: 100.0,
            padding: EdgeInsets.all(10.0),
            child: Image.asset(
              _menuIcon[index],
            )),
        Text(
          _menuTitle[index],
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
        ),
      ],
    );
  }
}
