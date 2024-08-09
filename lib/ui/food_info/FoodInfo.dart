import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/api/SPLPDApiId.dart';
import 'package:pontianak_smartcity/api/SPLPDApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyHttp.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'FoodInfoDetail.dart';

Widget _statusLogo(String status) {
  if (status == "Naik") {
    return Container(
      padding: EdgeInsets.all(0.0),
      color: Colors.red,
      child: Icon(
        Icons.arrow_drop_up,
        size: 20.0,
        color: Colors.white,
      ),
    );
  } else if (status == "Stabil") {
    return Container(
      padding: EdgeInsets.all(0.0),
      color: Colors.blue,
      child: Icon(
        Icons.drag_handle,
        size: 20.0,
        color: Colors.white,
      ),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(0.0),
      color: Colors.green,
      child: Icon(
        Icons.arrow_drop_down,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
}

class FoodInfo extends StatefulWidget {
  @override
  _FoodInfoState createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  //--- variable ---
  List _listCarousel = [];
  List _listFood = [];
  int _page = 1;
  //var _dataLoading = true;

  final defaultTargetPlatform = TargetPlatform.android;
  final MyHttp myHttp = MyHttp(); // ! Initial Helper Http

  //ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;

  //--- Method ---
  Future<String> showData(int page, String search, bool clearListParent) async {
    // setState(() {
    //   _dataLoading = true;
    // });

    List data = [];
    var param = "/${page.toString()}/${search}";
    final result = await myHttp.get(
        SPLPDApiService.hargaPangan + param, SPLPDApiId.hargaPanganApiId);

    if (result["status"] == "success") {
      _listCarousel = result["slider"];
      data = result["data"]["data"];

      if (data.length == 0) {
        setState(() {
          _page--;
          //_dataLoading = false;
          _refreshController.loadNoData();
        });
      } else {
        setState(() {
          if (clearListParent) _listFood.clear();
          _listFood.addAll(data);
          //_dataLoading = false;
          _refreshController.loadComplete();
        });
      }

      _refreshController.refreshCompleted();
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }

  void _onRefresh() {
    //use _refreshController.refreshComplete() or refreshFailed() to end refreshing
    showData(1, '0', true);
  }

  void _onLoading() {
    //use _refreshController.loadComplete() or loadNoData(),loadFailed() to end loading
    _page++;
    showData(_page, _searchController.text, false);
  }

  @override
  void initState() {
    // if you need refreshing when init,notice:initialRefresh is new  after 1.3.9
    _refreshController = RefreshController(
      initialRefresh: true,
    );

    showData(1, '0', true);

    // _scrollController.addListener((){
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     _page++;
    //     showData(_page, _searchController.text, false);
    //   }
    // });

    super.initState();
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final _searchBox = Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: MyString.search,
            icon: Icon(Icons.search),
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(ApiService.imagePlaceholder),
                        fit: BoxFit.cover),
                  ),
                ),
              ]
            : _listCarousel.map((f) {
                return Container(
                  child: Stack(children: <Widget>[
                    Image.network(ApiService.baseUrl2 + f["url_foto"],
                        fit: BoxFit.cover, width: 500.0),
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

    final _foodList = Expanded(
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
            _searchBox,
            _carouselFullScreen,
            GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _listFood == null ? 0 : _listFood.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int price = _listFood[index]["harga_barang"];

                  return _ViewHolderFoodInfo(
                    idFood: _listFood[index]["id"],
                    image: _listFood[index]["gambar"],
                    name: _listFood[index]["nama"],
                    status: _listFood[index]["status"],
                    dateUpdate: _listFood[index]["tgl_update"],
                    price: price,
                  );
                }),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.colorAppbar,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          MyString.commodityPrices.toUpperCase(),
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // _searchBox,
          _foodList,
          // _dataLoading ?
          // Container(
          //   height: 6.0,
          //   child: LinearProgressIndicator(),
          // ) :
          // Container(),
        ],
      ),
    );
  }
}

class _ViewHolderFoodInfo extends StatelessWidget {
  final int idFood, price;
  final String image, name, status, dateUpdate;
  const _ViewHolderFoodInfo(
      {Key? key,
      required this.idFood,
      required this.status,
      required this.price,
      required this.image,
      required this.name,
      required this.dateUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodInfoDetail(
                    id: idFood,
                  )),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: ApiService.baseUrl + "/" + image,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  height: 120.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text("Harga rata-rata"),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        MyHelper.formatRupiah(price),
                        style: status == "Naik"
                            ? TextStyle(fontSize: 12.0, color: Colors.red)
                            : status == "Stabil"
                                ? TextStyle(fontSize: 12.0, color: Colors.blue)
                                : TextStyle(
                                    fontSize: 12.0, color: Colors.green),
                      ),
                      Divider(
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                      Text(
                        MyHelper.returnToString(
                            "Update : " + MyHelper.formatShortDate(dateUpdate)),
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: _statusLogo(status),
            ),
          ),
        ],
      ),
    );
  }
}
