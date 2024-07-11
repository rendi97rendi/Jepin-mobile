import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pontianak_smartcity/common/MyCommon.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyHelperActivity.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:pontianak_smartcity/ui/event/EventDetail.dart';
import 'package:pontianak_smartcity/ui/google_map/MyGoogleMap.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/user/UserLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

String _userId = "";

class SouvenirDetail extends StatefulWidget {
  final String id;
  const SouvenirDetail({Key? key, required this.id}) : super(key: key);

  @override
  _SouvenirDetailState createState() => _SouvenirDetailState();
}

class _SouvenirDetailState extends State<SouvenirDetail> {
  // --- variable ---

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  //detail souvenir
  var _dataSouvenirDetail;
  List _listSouvenirEvent = [];
  List _listSouvenirImage = [];
  bool _loadingDetail = true;

  //review souvenir
  bool _loadingReview = true;
  var _dataSouvenirReview;
  List _listSouvenirReview = [];
  int _page = 1;

  bool _loadCreateReview = false;
  double _rating = 0;

  bool _loadDeleteReview = false;

  ScrollController _scrollController = new ScrollController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    showSouvenirDetail(this.widget.id);
    showSouvenirReview(this.widget.id, "1", true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page++;
        showSouvenirReview(this.widget.id, _page.toString(), false);
      }
    });

    _getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //--- widget ---

    final _fragmentDetail = _loadingDetail
        ? Container()
        : Container(
            color: Colors.indigo[50],
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                // --- Title ---
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        MyHelper.returnToString(_dataSouvenirDetail["nama"]),
                        //--- set value
                        style: TextStyle(
                            fontSize: MyFontSize.large,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        MyHelper.returnToString(_dataSouvenirDetail["alamat"]),
                        //--- set value
                        style: TextStyle(
                          fontSize: MyFontSize.small,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                // --- info ---
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 12.0, top: 16.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  MyString.info,
                                  style: TextStyle(
                                    fontSize: MyFontSize.small,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyGoogleMap(
                                              name: MyHelper.returnToString(
                                                  _dataSouvenirDetail["nama"]),
                                              lat: _dataSouvenirDetail["lat"] ==
                                                      null
                                                  ? 0.0
                                                  : double.parse(
                                                      _dataSouvenirDetail[
                                                          "lat"]),
                                              lon: _dataSouvenirDetail["lon"] ==
                                                      null
                                                  ? 0.0
                                                  : double.parse(
                                                      _dataSouvenirDetail[
                                                          "lon"]),
                                            )),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      MyString.openMap,
                                      style: TextStyle(
                                        fontSize: MyFontSize.small,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      Container(
                        // color: Colors.red,
                        child: HtmlWidget(
                          MyHelper.returnToString(
                              _dataSouvenirDetail["keterangan"]),
                          //--- set value
                          // builderCallback: (meta, e) =>
                          //     e.classes.contains('smilie')
                          //         ? lazySet(null, buildOp: smilieOp)
                          //         : meta,
                          onTapUrl: (v) {
                            return _launchURL(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                // --- address ---
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        MyString.detail,
                        style: TextStyle(
                          fontSize: MyFontSize.small,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyString.address,
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(":"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              MyHelper.returnToString(
                                  _dataSouvenirDetail["alamat"]),
                              //--- set value
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyString.kelurahan,
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(":"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              MyHelper.returnToString(_dataSouvenirDetail[
                                  "kelurahan"]), //--- set value
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                //--- Contact ---
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        MyString.contact,
                        style: TextStyle(
                          fontSize: MyFontSize.small,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyString.noHp,
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(":"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              MyHelper.returnToString(_dataSouvenirDetail[
                                  "no_telp"]), //--- set value
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                  text: _dataSouvenirDetail["no_telp"]));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(MyString.copyNoHp),
                              ));
                            },
                            child: Icon(Icons.content_copy),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyString.email,
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(":"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              MyHelper.returnToString(
                                  _dataSouvenirDetail["email"]),
                              //--- set value
                              style: TextStyle(fontSize: MyFontSize.medium),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                  text: _dataSouvenirDetail["email"]));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(MyString.copyEmail),
                              ));
                            },
                            child: Icon(Icons.content_copy),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ));

    final _listReview = ListView.builder(
      padding: EdgeInsets.all(0.0),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _listSouvenirReview == null ? 0 : _listSouvenirReview.length,
      itemBuilder: (context, index) {
        return Container(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  color: Colors.grey.withOpacity(.3),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Text(
                          _listSouvenirReview[index]["data_user"]["name"]
                              .toString(), //-- set value
                          style: TextStyle(
                            fontSize: MyFontSize.medium,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      // SmoothStarRating(
                      //     allowHalfRating: true,
                      //     starCount: 5,
                      //     rating: MyHelper.returnToDouble(
                      //         _listSouvenirReview[index]["rating"]),
                      //     //--- set value
                      //     size: 14.0,
                      //     color: Colors.green,
                      //     borderColor: Colors.green,
                      //     spacing: 0.0),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        MyHelper.returnToString(
                            _listSouvenirReview[index]["komentar"]),
                        //-- set value
                        style: TextStyle(
                          fontSize: MyFontSize.small,
                        ),
                      ),
                    ],
                  ),
                ),
                _listSouvenirReview[index]["user_id"].toString() ==
                        _userId.toString()
                    ? InkWell(
                        onTap: () {
                          deleteTourismReview(
                              _listSouvenirReview[index]["id"].toString());
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );

    final _fragmentReview = Container(
      color: Colors.indigo[50],
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          //--- Rating ---
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  MyString.rating,
                  style: TextStyle(
                    fontSize: MyFontSize.small,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _loadingReview
                          ? "-"
                          : MyHelper.returnToDouble(
                                  _dataSouvenirReview["rating_average"])
                              .toStringAsFixed(2),
                      style: TextStyle(fontSize: 50),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    // SmoothStarRating(
                    //     allowHalfRating: false,
                    //     onRated: (v) {},
                    //     starCount: 5,
                    //     rating: _loadingReview
                    //         ? 0
                    //         : MyHelper.returnToDouble(
                    //             _dataSouvenirReview["rating_average"]),
                    //     size: 20.0,
                    //     color: Colors.green,
                    //     borderColor: Colors.green,
                    //     spacing: 0.0),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          //--- Comment ---
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  MyString.comment,
                  style: TextStyle(
                    fontSize: MyFontSize.small,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _commentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: MyString.comment,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    // SmoothStarRating(
                    //     allowHalfRating: false,
                    //     onRated: (v) {
                    //       _rating = v;
                    //       setState(() {});
                    //     },
                    //     starCount: 5,
                    //     rating: _rating,
                    //     size: 30.0,
                    //     color: Colors.blue,
                    //     borderColor: Colors.blue,
                    //     spacing: 0.0),
                    SizedBox(
                      height: 16.0,
                    ),
                    _loadCreateReview
                        ? Center(
                            child: Container(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          ))
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlueAccent),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_commentController.text.isEmpty) {
                                MyHelper.toast(
                                  context,
                                  MyString.dataCannotEmpty,
                                );
                              } else {
                                MyHelperActivity.auth(() {
                                  createTourismReview();
                                }, () {
                                  MyHelper.toast(context, MyString.loginFirst,
                                      gravity: Toast.center);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()),
                                  );
                                });
                              }
                            },
                            // color: Colors.lightBlueAccent,
                            child: Text(MyString.send,
                                style: TextStyle(color: Colors.white)),
                          ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          //--- Review ---
          _listReview,
          _loadingReview
              ? Container(
                  height: 6.0,
                  child: LinearProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );

    final _fragmentEvent = Container(
      child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: _listSouvenirEvent == null ? 0 : _listSouvenirEvent.length,
          itemBuilder: (BuildContext context, int index) {
            if (_listSouvenirEvent == null) {
              return Container();
            } else {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetail(
                              idEvent:
                                  _listSouvenirEvent[index]["id"].toString(),
                            )),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Stack(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: ApiService.baseUrl2 +
                          _listSouvenirEvent[index]["gambar"], //--- set value
                      placeholder: (context, url) => Center(
                          child: Container(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                      )),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              MyHelper.returnToString(
                                  _listSouvenirEvent[index]["nama"]),
                              //--- set value
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
                              MyHelper.formatShortDate(_listSouvenirEvent[index]
                                      ["tanggal_mulai"]) +
                                  " s/d " +
                                  MyHelper.formatShortDate(
                                      _listSouvenirEvent[index]
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
                  ]),
                ),
              );
            }
          }),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: _dataSouvenirDetail == null
                      ? Container()
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                          ),
                          items: _listSouvenirImage
                              .asMap()
                              .map((i, element) => MapEntry(
                                    i,
                                    CachedNetworkImage(
                                      imageUrl: _listSouvenirImage.length == 0
                                          ? "https://www.logistec.com/wp-content/uploads/2017/12/placeholder.png"
                                          : ApiService.baseUrl +
                                              ApiService.urlImageHotel +
                                              _listSouvenirImage[i]["nama"],
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              .values
                              .toList(),
                        ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: TabBar(
                      labelColor: Colors.white,
                      tabs: [
                        Tab(text: MyString.placeInfo),
                        Tab(text: MyString.review),
                        Tab(text: MyString.event),
                      ],
                    ),
                  ),
                ),
                title: _dataSouvenirDetail == null
                    ? Text("")
                    : Text(
                        _dataSouvenirDetail["nama"],
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _dataSouvenirDetail == null ? LayoutLoading() : _fragmentDetail,
              _fragmentReview,
              _fragmentEvent,
            ],
          ),
        ),
      ),
    );
  }

  Future<String> showSouvenirDetail(String id) async {
    setState(() {
      _loadingDetail = true;
    });

    var param = "/" + id;

    var response = await http.get(
      Uri.parse(ApiService.hotelDetail + param),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _dataSouvenirDetail = result["data"];
        _listSouvenirEvent = result["data"]["event"];
        _listSouvenirImage = result["data"]["details"];

        setState(() {
          _loadingDetail = false;
        });
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }

  Future<String> showSouvenirReview(
      String id, String page, bool clearListParent) async {
    setState(() {
      _loadingReview = true;
    });

    var param = "/" + id + "?page=" + page;

    var response = await http.get(
      Uri.parse(ApiService.hotelReviewList + param),
      headers: {"Accept": "application/json"},
    );

    List data = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _dataSouvenirReview = result;
        data = result["data"]["data"];

        if (data.length == 0) {
          setState(() {
            _page--;
          });
        } else {
          setState(() {
            if (clearListParent) _listSouvenirReview.clear();
            _listSouvenirReview.addAll(data);
          });
        }

        setState(() {
          _loadingReview = false;
        });
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }

  Future<String> createTourismReview() async {
    setState(() {
      _loadCreateReview = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map["rating"] = _rating.toString();
    map["komentar"] = _commentController.text;
    map["hotel_id"] = this.widget.id.toString();
    map["user_id"] = prefs.getString(MyConstanta.userId);

    var response = await http.post(Uri.parse(ApiService.hotelReviewCreate),
        headers: {
          "Accept": "application/json",
          "Authorization": prefs.getString(MyConstanta.saveToken) ?? ''
        },
        body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        MyHelper.toast(context, MyHelper.returnToString(result["message"]),
            gravity: Toast.center);
        _commentController.clear();
        _page = 1;
        showSouvenirReview(this.widget.id, "1", true);
      } else {
        MyHelper.toast(context, MyString.msgError);
      }

      setState(() {
        _loadCreateReview = false;
        _rating = 0;
      });
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;

      setState(() {
        _loadCreateReview = false;
      });
    }

    return "Success!";
  }

  Future<String> deleteTourismReview(String idTourismReview) async {
    setState(() {
      _loadDeleteReview = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map["id"] = idTourismReview;

    var response = await http.post(Uri.parse(ApiService.hotelReviewDelete),
        headers: {
          "Accept": "application/json",
          "Authorization": prefs.getString(MyConstanta.saveToken) ?? ''
        },
        body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        MyHelper.toast(context, MyHelper.returnToString(result["message"]),
            gravity: Toast.center);

        _listSouvenirReview.clear();
        _page = 1;
        showSouvenirReview(this.widget.id, "1", true);
      } else {
        MyHelper.toast(context, MyString.msgError);
      }

      setState(() {
        _loadDeleteReview = false;
      });
    } else {
      MyHelper.toast(context, MyString.msgError);

      setState(() {
        _loadDeleteReview = false;
      });
    }

    return "Success!";
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString(MyConstanta.userId) ?? '';
  }

  _launchURL(String urlx) async {
    String url = urlx; //--- set value
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
