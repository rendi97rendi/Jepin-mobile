import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:pontianak_smartcity/master_layout/MyLayoutImage.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

const _kSmilies = {':)': '🙂'};

class NewsDetail extends StatefulWidget {
  final int id;
  const NewsDetail({Key? key, required this.id}) : super(key: key);

  // final String titleBar, date, content;
  // const NewsDetail({Key key, this.titleBar, this.content, this.date}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  var _dataNewsDetail;
  var _loadingNewsDetail = true;
  var image;
  String? url;
  PageController _scrollController =
      PageController(initialPage: 0, keepPage: true);

  // final smilieOp = BuildOp(
  //   onWidgets: (meta, pieces) {
  //     final alt = meta.element.attributes['alt'];
  //     final text = _kSmilies.containsKey(alt) ? _kSmilies[alt] : alt;
  //     return pieces..first?.block?.addText(text);
  //   },
  // );

  @override
  void initState() {
    showData(this.widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageContent = _loadingNewsDetail
        ? LayoutLoading()
        : Container(
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(12.0),
              child: MyLayoutImage(
                fit: BoxFit.cover,
                image: ApiService.newsDetailImage + image[0],
                width: double.infinity,
                height: 250,
              ),
            ),
          );

    final bodyContent = _loadingNewsDetail
        ? LayoutLoading()
        : Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    MyHelper.returnToString(_dataNewsDetail["judul_berita"]),
                    style: TextStyle(
                        fontSize: MyFontSize.large,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          MyHelper.formatShortDate(
                              _dataNewsDetail["tanggal_berita"]),
                          style: TextStyle(
                            fontSize: MyFontSize.small,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          'Oleh : ' + _dataNewsDetail["penulis_berita"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MyFontSize.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    _dataNewsDetail["isi_berita"],
                    // builderCallback: (meta, e) => e.classes.contains('smilie')
                    //     ? lazySet(null, buildOp: smilieOp)
                    //     : meta,
                    onTapUrl: (v) {
                      return _launchURL(v);
                    },
                  ),
                ),
              ],
            ),
          );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Text(
          MyString.news.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (url != null) _launchURL(url!);
            },
            icon: Icon(
              Icons.language_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _loadingNewsDetail
          ? LayoutLoading()
          : Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [imageContent, bodyContent],
                ),
              )),
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
    );
  }

  Future<String> showData(int id) async {
    setState(() {
      _loadingNewsDetail = true;
    });

    var param = "/" + id.toString();
    var response = await http.get(
      Uri.parse(ApiService.berita + param),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);
      if (result["status"] == true) {
        _dataNewsDetail = result["data"];
        image = jsonDecode(_dataNewsDetail['img_berita']);
        // print(_dataNewsDetail['judul_berita']);
        url = MyHelper.encodeURL(_dataNewsDetail['judul_berita']);
        // print(url);
      } else {
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    setState(() {
      _loadingNewsDetail = false;
    });

    return "Success!";
  }

  _launchURL(String urlx) async {
    String url = urlx; //--- set value

    await launch(
      url,
      enableJavaScript: true,
    );
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}
