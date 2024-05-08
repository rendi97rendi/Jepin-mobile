import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/ui/food_info/FoodInfoDetail.dart';
import 'package:pontianak_smartcity/ui/news/NewsDetail.dart';
import 'package:pontianak_smartcity/ui/tourism/TourismDetail.dart';
import 'package:pontianak_smartcity/ui/webview/MyWebview.dart';
import 'dart:convert';

import 'package:toast/toast.dart';

List _dataNews = [];
List _dataWebEmbed = [];
List _listAnnouncements = [];
List _listEvent = [];
List _infografis = [];
List _hotelResto = [];
List _tourism = [];
List _commodity = [];

var _dataLoading = true;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<String> showData(String search) async {
    setState(() {
      _dataLoading = true;
    });

    var param = "?q=" + search;

    var response = await http.get(
      Uri.parse(ApiService.search + param),
      headers: {"Accept": "application/json"},
    );

    //List data = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        setState(() {
          _dataNews = result["data"]["berita"];
          _dataWebEmbed = result["data"]["webEmbed"];
          _listAnnouncements = result["data"]["pengumuman"];
          _listEvent = result["data"]["agenda"];
          _infografis = result["data"]["infografis"];
          _hotelResto = result["data"]["hotelresto"];
          _tourism = result["data"]["wisata"];
          _commodity = result["data"]["komoditi"];

          _dataLoading = false;
        });
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }

  @override
  void initState() {
    setState(() {
      _dataLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        title: Text("Search"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: MyString.search,
                  icon: Icon(Icons.search),
                ),
                onChanged: (text) {
                  Timer(Duration(milliseconds: 300), () {
                    showData(text);
                  });
                },
              ),
            ),
          ),
          Expanded(
              child: _dataLoading == true
                  ? Center(
                      child: Container(
                        height: 6.0,
                        width: 140.0,
                        child: LinearProgressIndicator(),
                      ),
                    )
                  : ListView(
                      children: <Widget>[
                        //--- News ---
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Berita",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            itemCount: _dataNews == null ? 0 : _dataNews.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (_dataNews[0] == null) {
                                return Container();
                              } else {
                                return _dataNews == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetail(
                                                      id: _dataNews[index]
                                                          ["id"],
                                                    )),
                                          );
                                        },
                                        child: _ViewHolderSearch(
                                          title: _dataNews[index]["judul"],
                                        ),
                                      );
                              }
                            }),

                        //--- Web Embeded ---
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Web Embedded",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            itemCount: _dataWebEmbed == null
                                ? 0
                                : _dataWebEmbed.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (_dataWebEmbed[0] == null) {
                                return Container();
                              } else {
                                return _dataWebEmbed == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyWebview(
                                                      title:
                                                          _dataWebEmbed[index]
                                                              ["judul"],
                                                      url: ApiService.baseUrl2 +
                                                          _dataWebEmbed[index]
                                                              ["slug"],
                                                    )),
                                          );
                                        },
                                        child: _ViewHolderSearch(
                                          title: _dataWebEmbed[index]["judul"],
                                        ),
                                      );
                              }
                            }),

                        //--- Infografis ---
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Infografis",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            itemCount:
                                _infografis == null ? 0 : _infografis.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (_infografis[0] == null) {
                                return Container();
                              } else {
                                return _infografis == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyWebview(
                                                      title: _infografis[index]
                                                          ["judul"],
                                                      url: ApiService.baseUrl2 +
                                                          "infografis/" +
                                                          _infografis[index]
                                                              ["slug"],
                                                    )),
                                          );
                                        },
                                        child: _ViewHolderSearch(
                                          title: _infografis[index]["judul"],
                                        ),
                                      );
                              }
                            }),

                        //--- Hotel / Restorant ---
                        // SizedBox(height: 16.0,),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("Hotel & Resto", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        // ),
                        // ListView.builder(
                        //   itemCount: _hotelResto == null ? 0 : _hotelResto.length,
                        //   physics: ScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     if (_hotelResto[0] == null) {
                        //       return Container();
                        //     } else {
                        //       return _infografis == null ? Container() : InkWell(
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //   context,
                        //           //   MaterialPageRoute(
                        //           //     builder: (context) => MyWebview(
                        //           //       title: _infografis[index]["judul"],
                        //           //       url: ApiService.baseUrl2 + "infografis/" + _infografis[index]["slug"],
                        //           //     )
                        //           //   ),
                        //           // );
                        //         },
                        //         child: _ViewHolderSearch(
                        //           title: _hotelResto[index]["judul"],
                        //         ),
                        //       );
                        //     }
                        //   }
                        // ),

                        //--- Wisata ---
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Wisata",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            itemCount: _tourism == null ? 0 : _tourism.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (_tourism[0] == null) {
                                return Container();
                              } else {
                                return _tourism == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TourismDetail(
                                                      id: _tourism[index]["id"]
                                                          .toString(),
                                                    )),
                                          );
                                        },
                                        child: _ViewHolderSearch(
                                          title: _tourism[index]["judul"],
                                        ),
                                      );
                              }
                            }),

                        //--- Commodity ---
                        SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Komoditas",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                            itemCount:
                                _commodity == null ? 0 : _commodity.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (_commodity[0] == null) {
                                return Container();
                              } else {
                                return _commodity == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FoodInfoDetail(
                                                      id: _commodity[index]
                                                          ["id"],
                                                    )),
                                          );
                                        },
                                        child: _ViewHolderSearch(
                                          title: _commodity[index]["judul"],
                                        ),
                                      );
                              }
                            }),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}

class _ViewHolderSearch extends StatelessWidget {
  final title;
  const _ViewHolderSearch({Key? key, this.title = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_right),
          SizedBox(
            width: 8.0,
          ),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}
