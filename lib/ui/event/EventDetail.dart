import 'dart:ui' as prefix0;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/api/SPLPDApiId.dart';
import 'package:pontianak_smartcity/api/SPLPDApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyCommon.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyHttp.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/culinary/CulinaryDetail.dart';
import 'package:pontianak_smartcity/ui/hotel/HotelDetail.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/tourism/TourismDetail.dart';
import 'package:toast/toast.dart';

class EventDetail extends StatefulWidget {
  final String idEvent;
  const EventDetail({Key? key, required this.idEvent}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  // --- variable ---
  var _dataEventDetail;
  var _urlTempImg = SPLPDApiService.imagePlaceholder;
  List _listEventLocation = [];
  bool _loadingEventDetail = true;
  final MyHttp myHttp = MyHttp(); // ! Initial Helper Http
  final String _imgPlaceholder = SPLPDApiService.imagePlaceholder;
  PageController _scrollController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    showEventDetail(this.widget.idEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _widgetImage = CachedNetworkImage(
      imageUrl: _urlTempImg,
      placeholder: (context, url) => Center(
          child: Container(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(),
      )),
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.error),
      ),
      fit: BoxFit.fill,
    );

    final _widgetHeader = Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: _loadingEventDetail
          ? LayoutLoading()
          : Column(
              children: <Widget>[
                Text(
                  MyHelper.returnToString(
                      _dataEventDetail["nama"]), //--- set value
                  style: TextStyle(
                      fontSize: MyFontSize.large, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  MyHelper.formatShortDate(_dataEventDetail["tanggal_mulai"]) +
                      " s/d " +
                      MyHelper.formatShortDate(
                          _dataEventDetail["tanggal_selesai"]), //--- set value
                  style: TextStyle(
                    fontSize: MyFontSize.small,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );

    final _widgetContent = Container(
      color: Colors.white,
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: _loadingEventDetail
          ? LayoutLoading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 16.0),
                  child: Text(
                    MyString.info,
                    style: TextStyle(
                      fontSize: MyFontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  child: HtmlWidget(
                    MyHelper.returnToString(
                        _dataEventDetail["keterangan"]), //--- set value
                    // builderCallback: (meta, e) => e.classes.contains('smilie')
                    //     ? lazySet(null, buildOp: smilieOp)
                    //     : meta,
                  ),
                ),
              ],
            ),
    );

    final _widgetLocation = Container(
      height: 140.0,
      color: Colors.white,
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: _loadingEventDetail
          ? LayoutLoading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 16.0),
                  child: Text(
                    MyString.location,
                    style: TextStyle(
                      fontSize: MyFontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _listEventLocation == null
                          ? 0
                          : _listEventLocation.length, //--- set value
                      itemBuilder: (BuildContext context, int index) {
                        if (0 == null) {
                          return Container();
                        } else {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return _listEventLocation[index]
                                              ["kategori"] ==
                                          "wisata"
                                      ? TourismDetail(
                                          id: _listEventLocation[index]["id"]
                                              .toString())
                                      : _listEventLocation[index]["kategori"] ==
                                              "penginapan"
                                          ? HotelDetail(
                                              id: _listEventLocation[index]
                                                      ["id"]
                                                  .toString())
                                          : CulinaryDetail(
                                              id: _listEventLocation[index]
                                                      ["id"]
                                                  .toString());
                                }),
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.all(4.0),
                                child: Material(
                                  elevation: 3.0,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl:
                                                    _listEventLocation[index]
                                                        ["detail"]["nama"],
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child: Container(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Icon(Icons.error),
                                                ),
                                                fit: BoxFit.cover,
                                                width: 150.0,
                                                height: 100.0,
                                              ),
                                              BackdropFilter(
                                                filter:
                                                    prefix0.ImageFilter.blur(
                                                  sigmaX: 2,
                                                  sigmaY: 2,
                                                ),
                                                child: Container(
                                                  width: 150.0,
                                                  height: 100.0,
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        width: 150.0,
                                        height: 100.0,
                                        child: Center(
                                          child: Text(
                                            _listEventLocation[index]["nama"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }
                      }),
                ),
              ],
            ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: MyColor.colorAppbar,
        title: Text(
          MyString.event.toUpperCase(),
          style: TextStyle(
            fontSize: MyFontSize.large,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 10, bottom: 30),
        height: 52.0,
        width: 52.0,
        child: FittedBox(
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Colors.amber,
            splashColor: Colors.orange[400],
            onPressed: () {
              setState(() {
                _scrollController.animateToPage(0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
            // elevation: 5.0,
          ),
        ),
      ),
      backgroundColor: Colors.indigo[50],
      body: _loadingEventDetail
          ? LayoutLoading()
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _widgetImage,
                  _widgetHeader,
                  _widgetContent,
                  _widgetLocation,
                ],
              )),
    );
  }

  //--- method ---
  Future<String> showEventDetail(String idEvent) async {
    setState(() {
      _loadingEventDetail = true;
    });

    final result = await myHttp.get(
        '${SPLPDApiService.detailEvent}/$idEvent', SPLPDApiId.detailEventApiId);
    try {
      if (result["status"] == "success") {
        _dataEventDetail = result["data"];

        if (_dataEventDetail["url_gambar"] == null ||
            _dataEventDetail["url_gambar"] == 'null' ||
            _dataEventDetail["url_gambar"]?.isEmpty) {
          _dataEventDetail["gambar"] = _imgPlaceholder;
        } else {
          _dataEventDetail["gambar"] = _dataEventDetail["url_gambar"];
        }
        _listEventLocation = result["data"]["lokasi_event"];

        setState(() {
          _urlTempImg = _dataEventDetail["gambar"];
          _loadingEventDetail = false;
        });
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }
}
