import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/tourism/TourismDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

String? _urlImage;

class TourismListLama extends StatefulWidget {
  final String title;
  const TourismListLama({Key? key, required this.title}) : super(key: key);

  @override
  _TourismListLamaState createState() => _TourismListLamaState();
}

class _TourismListLamaState extends State<TourismListLama> {
  // --- variable ---
  String _category = "";
  List _listTourismCategory = [];
  var _loadingTourismCategory = true;

  List _listCarousel = [];
  List _listTourism = [];
  int _page = 1;
  bool _dataLoading = false;

  final defaultTargetPlatform = TargetPlatform.android;

  // ScrollController _scrollController = new ScrollController();
  TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;

  @override
  void initState() {
    // if you need refreshing when init,notice:initialRefresh is new  after 1.3.9
    _refreshController = RefreshController(
      initialRefresh: true,
    );

    tourismCategory();
    showData(1, "", _category, true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _widgetSearchBox = Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.only(bottom: 10, top: 5, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 232, 230),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: MyString.search + " " + this.widget.title,
          labelStyle: TextStyle(color: Colors.black45),
          hintText: MyString.search + " " + this.widget.title,
          hintStyle: TextStyle(color: Colors.black45),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              clearTextField();
            },
            icon: Icon(Icons.clear),
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 250, 238, 238), width: 1.0,
              style: BorderStyle.solid,
              // color: Colors.black,
            ),
          ),
        ),
        onChanged: (text) {
          Timer(Duration(milliseconds: 300), () {
            _page = 1;
            showData(_page, text, _category, true);
          });
        },
      ),
    );

    final _carouselFullScreen = CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,
          aspectRatio: 2.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enlargeCenterPage: false,
        ),
        items: _listCarousel.length == 0
            ? <Widget>[
                Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: ApiService.imagePlaceholder, //--- set value
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: new CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ]
            : _listCarousel.map((f) {
                return Container(
                  child: Stack(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          ApiService.baseUrl2 + f["url_foto"], //--- set value
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: new CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
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
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              f["judul"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MyFontSize.large,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              f["keterangan"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MyFontSize.small,
                                //fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                );
              }).toList());

    final _tourismList = _dataLoading
        ? LayoutLoading()
        : Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: defaultTargetPlatform == TargetPlatform.iOS
                  ? WaterDropHeader()
                  : WaterDropMaterialHeader(
                      backgroundColor: Colors.orange,
                    ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView(
                //controller: _scrollController,
                children: <Widget>[
                  GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _listTourism == null ? 0 : _listTourism.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.23,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TourismDetail(
                                        id: _listTourism[index]["id"]
                                            .toString(),
                                      )),
                            );
                          },
                          child: _ViewHolderTourism(
                            image: _listTourism[index]["details"],
                            name: _listTourism[index]["nama"],
                            address: _listTourism[index]["alamat"],
                          ),
                        );
                      }),
                ],
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: MyColor.colorAppbar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text(
          this.widget.title.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.white,
            onPressed: () {
              _dialogCategory();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _carouselFullScreen,
          SizedBox(
            height: 5,
          ),
          _widgetSearchBox,
          SizedBox(
            height: 5,
          ),
          _tourismList,
        ],
      ),
    );
  }

  // --- Method ---
  Future<String> showData(
      int page, String search, String category, bool clearListParent) async {
    // setState(() {
    //   _dataLoading = true;
    // });

    var param = "?page=" +
        page.toString() +
        "&search=" +
        search +
        "&category=" +
        category;

    var response = await http.get(
      Uri.parse(ApiService.tourismList + param),
      headers: {"Accept": "application/json"},
    );

    List data = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _listCarousel = result["slider"];
        _urlImage = result["url_file"];
        data = result["data"]["data"];

        if (clearListParent) _listTourism.clear();

        if (data.length == 0) {
          setState(() {
            _page--;
            _refreshController.loadNoData();
          });
        } else {
          setState(() {
            _listTourism.addAll(data);
            _refreshController.loadComplete();
          });
        }

        _refreshController.refreshCompleted();
      } else {
        MyHelper.toast(context, MyString.msgError);
        ;
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    setState(() {
      _dataLoading = false;
    });

    return "Success!";
  }

  Future<String> tourismCategory() async {
    setState(() {
      _loadingTourismCategory = true;
    });

    var response = await http.get(
      Uri.parse(ApiService.tourismCategory),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        _listTourismCategory = result["data"];
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    setState(() {
      _loadingTourismCategory = false;
    });

    return "Success!";
  }

  void _onRefresh() {
    //use _refreshController.refreshComplete() or refreshFailed() to end refreshing
    showData(1, "", _category, true);
  }

  void _onLoading() {
    //use _refreshController.loadComplete() or loadNoData(),loadFailed() to end loading
    _page++;
    showData(_page, _searchController.text, _category, false);
  }

  void _dialogCategory() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              title: Text(
                "Information",
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Container(
                height: 300,
                width: double.infinity,
                child: Container(
                  child: Column(
                    children: [
                      Divider(),
                      Container(
                        height: 250,
                        width: 400,
                        child: ListView.builder(
                          itemCount: _listTourismCategory == null
                              ? 1
                              : _listTourismCategory.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if ((_listTourismCategory.length + 1) ==
                                (index + 1)) {
                              return _listTourismCategory == null
                                  ? Container()
                                  : Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _dataLoading = true;
                                              _category = "";

                                              _page = 1;
                                              showData(
                                                  _page, "", _category, true);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: ListTile(
                                            title: Text("Semua"),
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                            } else {
                              return _listTourismCategory == null
                                  ? Container()
                                  : Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _dataLoading = true;
                                              _category =
                                                  _listTourismCategory[index]
                                                          ["id"]
                                                      .toString();

                                              _page = 1;
                                              showData(
                                                  _page, "", _category, true);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: ListTile(
                                            title: Text(
                                                _listTourismCategory[index]
                                                    ["nama_kategori"]),
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void clearTextField() {
    _searchController.clear();
    showData(1, "", _category, true);
  }
}

class _ViewHolderTourism extends StatelessWidget {
  final List image;
  final String name, address;

  const _ViewHolderTourism(
      {Key? key, required this.image, this.name = "", this.address = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: image.length == 0
                ? ApiService.imagePlaceholder
                : ApiService.baseUrl2 + _urlImage! + image[0]["nama"],
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: new CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            height: 120.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    address.substring(0, 45) + "...",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: MyFontSize.small,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
