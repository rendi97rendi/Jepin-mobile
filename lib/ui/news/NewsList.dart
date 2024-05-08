import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/master_layout/MyLayoutImage.dart';
import 'package:pontianak_smartcity/ui/dashboard/SmartCity.dart';
import 'package:pontianak_smartcity/ui/news/NewsDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  // --- variable ---
  List _listNews = [];
  int _page = 1;

  final defaultTargetPlatform = TargetPlatform.android;

  TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;
  PageController _myPage = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    // if you need refreshing when init,notice:initialRefresh is new  after 1.3.9
    _refreshController = RefreshController(
      initialRefresh: true,
    );

    showData(1, "", true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _widgetSearchBox = Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 4.0),
      color: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: MyString.search + " " + MyString.news,
            icon: Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                clearTextField();
              },
              icon: Icon(Icons.clear),
            ),
          ),
          onChanged: (text) {
            Timer(Duration(milliseconds: 300), () {
              _page = 1;
              showData(_page, text, true);
            });
          },
        ),
      ),
    );

    final _newsList = Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: defaultTargetPlatform == TargetPlatform.iOS
            ? WaterDropHeader()
            : WaterDropMaterialHeader(
                backgroundColor: colorNav,
              ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          controller: _myPage,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _listNews == null ? 0 : _listNews.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_listNews == null) {
                    return Container();
                  } else {
                    if (index == 0) {
                      return _ViewHolderNewsWide(
                        id: _listNews[index]["id"],
                        index: index,
                        image: jsonDecode(_listNews[index]["img_berita"]),
                        title: _listNews[index]["judul_berita"],
                        content: _listNews[index]["isi_berita"],
                        date: _listNews[index]["tanggal_berita"],
                        writer: _listNews[index]["penulis_berita"],
                        status: 'PUBLISHED',
                      );
                    } else {
                      return _ViewHolderNewsList(
                        id: _listNews[index]["id"],
                        index: index,
                        image: jsonDecode(_listNews[index]["img_berita"]),
                        title: _listNews[index]["judul_berita"],
                        content: _listNews[index]["isi_berita"],
                        date: _listNews[index]["tanggal_berita"],
                        writer: _listNews[index]["penulis_berita"],
                        status: 'PUBLISHED',
                      );
                    }
                  }
                }),
          ],
          // physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.;
        ),
      ),
    );

    // final _floatingButtonToTop = FloatingActionButton(onPressed: () {

    //   },

    //   child: Icon(Icons.arrow_upward),
    //   ),
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        leading: Icon(
          Icons.newspaper,
          color: Colors.white,
        ),
        title: Text(
          MyString.news.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _widgetSearchBox,
          _newsList,
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 10, bottom: 10),
        height: 52.0,
        width: 52.0,
        child: FittedBox(
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Colors.amber,
            splashColor: Colors.orange[400],
            onPressed: () {
              setState(() {
                _myPage.animateToPage(0,
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

  Future<String> showData(int page, String search, bool clearListParent) async {
    var param = "?page=" + page.toString() + "&q=" + search;

    var response = await http.get(
      Uri.parse(ApiService.berita + param),
      headers: {"Accept": "application/json"},
    );

    List<dynamic> data = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);
      // print(result);
      if (result["status"] == true) {
        var newData = result['data']['data'] as List<dynamic>;
        // print(data);
        // inspect(newData[0]['id']);
        data = newData;
        // print(data[0]['img_gambar']);
        if (data.length == 0) {
          setState(() {
            _page--;
            _refreshController.loadNoData();
          });
        } else {
          if (clearListParent) _listNews.clear();
          _listNews.addAll(data);
          // print(_listNews.length);
          _refreshController.loadComplete();
          setState(() {});
        }

        _refreshController.refreshCompleted();
      } else {
        // print('terjadi kesalahan');
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      // print('error');
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }

  void _onRefresh() {
    //use _refreshController.refreshComplete() or refreshFailed() to end refreshing
    showData(1, "", true);
  }

  void _onLoading() {
    //use _refreshController.loadComplete() or loadNoData(),loadFailed() to end loading
    _page++;
    showData(_page, _searchController.text, false);
  }

  void clearTextField() {
    _searchController.clear();
    showData(1, "", true);
  }
}

// --- ViewHolder ---

class _ViewHolderNewsList extends StatelessWidget {
  final int id, index;
  final List image;
  final String title, content, date, status, writer;

  const _ViewHolderNewsList(
      {Key? key,
      required this.image,
      this.title = "",
      this.status = "",
      required this.index,
      required this.date,
      this.writer = "",
      this.content = "",
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetail(
                    id: id,
                  )),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 243, 243, 243),
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        elevation: 0.0,
        child: Container(
            // decoration: BoxDecoration(
            //     border: Border.all(
            //         color: const Color.fromARGB(255, 168, 168, 168), width: 1, style: BorderStyle.solid),
            //         borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              // borderRadius: BorderRadius.circular(12.0),
              child: MyLayoutImage(
                fit: BoxFit.cover,
                image: image.isNotEmpty
                    ? ApiService.newsDetailImage + image[0]
                    : ApiService.imagePlaceholder,
                height: 140.0,
                width: 140.0,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MyFontSize.medium,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Text(
                        writer,
                        style: TextStyle(
                            fontSize: MyFontSize.small, color: Colors.orange),
                      ),
                    ),
                    Container(
                      child: Text(
                        MyHelper.formatShortDate(date),
                        style: TextStyle(
                            fontSize: MyFontSize.small, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _ViewHolderNewsWide extends StatelessWidget {
  final int id, index;
  final List image;
  final String title, content, date, status, writer;

  const _ViewHolderNewsWide(
      {Key? key,
      required this.image,
      this.title = "",
      this.status = "",
      required this.index,
      required this.date,
      required this.writer,
      this.content = "",
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetail(
                    id: id,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: Stack(children: <Widget>[
            MyLayoutImage(
              fit: BoxFit.cover,
              image: image.isNotEmpty
                  ? ApiService.newsDetailImage + image[0]
                  : ApiService.imagePlaceholder,
              height: MediaQuery.of(context).size.width - 100,
              width: double.infinity,
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MyFontSize.medium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      MyHelper.formatShortDate(date),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MyFontSize.small,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
