import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:toast/toast.dart';

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
  } else if (status == "Stabil" || status == "Tidak ada data") {
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

Widget _inflasiLogo(String inflasiColor) {
  if (inflasiColor == "red") {
    return Container(
      padding: EdgeInsets.all(0.0),
      color: Colors.red,
      child: Icon(
        Icons.arrow_drop_up,
        size: 20.0,
        color: Colors.white,
      ),
    );
  } else if (inflasiColor == "yellow") {
    return Container(
      padding: EdgeInsets.all(0.0),
      color: Colors.yellow,
      child: Icon(
        Icons.arrow_drop_up,
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

class FoodInfoDetail extends StatefulWidget {
  final int id;

  const FoodInfoDetail({Key? key, required this.id}) : super(key: key);

  @override
  _FoodInfoDetailState createState() => _FoodInfoDetailState();
}

class _FoodInfoDetailState extends State<FoodInfoDetail> {
  //--- variable ---
  var _loadingMarket = true;
  var _dataFood;
  List _listMarket = [];

  final _pageController = PageController(
    initialPage: 0,
  );

  //--- method ---

  Future<String> showData(int idFood) async {
    setState(() {
      _loadingMarket = true;
    });

    // print('show Pangan id : ' + idFood.toString());

    var response = await http.get(
        Uri.parse(ApiService.foodInfo + "/" + idFood.toString()),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);

      if (result["status"] == "success") {
        setState(() {
          _dataFood = result["data"];
          _listMarket = result["data"]["pasar"];
          _loadingMarket = false;
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

  @override
  void initState() {
    showData(this.widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //--- widget ---

    final detail = Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: _loadingMarket
          ? LayoutLoading()
          : Column(
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
                //--- price average
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyString.priceAverage,
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          _statusLogo(_dataFood["status"]),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            MyHelper.formatRupiah(MyHelper.returnToInt(
                                _dataFood["harga_barang"])),
                            style: TextStyle(fontSize: MyFontSize.medium),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                //--- date update
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyString.dateUpdate,
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        (_dataFood["tgl_update"] == null ||
                                _dataFood["tgl_update"] == "")
                            ? "-"
                            : MyHelper.formatShortDate(
                                    _dataFood["tgl_update"]) +
                                "\n" +
                                MyHelper.returnToString(
                                    _dataFood["waktu_survey"]),
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                //min price
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyString.minPrice,
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        MyHelper.formatRupiah(
                            MyHelper.returnToInt(_dataFood["harga_terendah"])),
                        //      +
                        // " (" +
                        // MyHelper.returnToString(
                        //     _dataFood["pasar_harga_terendah"]) +
                        // ")",
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                //--- max price
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyString.maxPrice,
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(":"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        MyHelper.formatRupiah(
                            MyHelper.returnToInt(_dataFood["harga_tertinggi"])),
                        //   +
                        // " (" +
                        // MyHelper.returnToString(
                        //     _dataFood["pasar_harga_tertinggi"]) +
                        // ")",
                        style: TextStyle(fontSize: MyFontSize.medium),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
    );

    final tableHeader = Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              "Tanggal",
              style: TextStyle(
                  fontSize: MyFontSize.medium, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Harga",
              style: TextStyle(
                  fontSize: MyFontSize.medium, fontWeight: FontWeight.bold),
            ),
          ),
//          Expanded(
//            flex: 2,
//            child: Text("Inflasi", style: TextStyle(fontSize: MyFontSize.medium, fontWeight: FontWeight.bold),),
//          )
        ],
      ),
    );

    final pageMarket = Container(
      height: 400.0,
      child: _loadingMarket
          ? LayoutLoading()
          : PageView.builder(
              controller: _pageController,
              itemCount: _listMarket.length == null ? 0 : _listMarket.length,
              scrollDirection: Axis.horizontal,
              reverse: false,
              itemBuilder: (BuildContext context, int index) {
                List _commodityPrice = _listMarket[index]["harga_komoditas"];

                return Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _pageController.previousPage(
                                    duration: kTabScrollDuration,
                                    curve: Curves.ease);
                              },
                              child: Icon(Icons.chevron_left),
                            ),
                            Expanded(
                              child: Text(
                                MyHelper.returnToString(
                                    _listMarket[index]["nama"]),
                                style: TextStyle(
                                    fontSize: MyFontSize.large,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _pageController.nextPage(
                                    duration: kTabScrollDuration,
                                    curve: Curves.ease);
                              },
                              child: Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Divider(),
                        tableHeader,
                        Divider(),
                        SizedBox(
                          height: 8.0,
                        ),
                        Expanded(
                          child: ListView(
                              padding: EdgeInsets.all(0.0),
                              children: _commodityPrice.map((f) {
                                return _ViewHolderCommodityPrice(
                                  date: MyHelper.formatShortDate(
                                      MyHelper.returnToString(f["tanggal"])),
                                  price: MyHelper.formatRupiah(
                                      MyHelper.returnToInt(f["harga"])),
                                  status: MyHelper.returnToString(f["status"]),
                                  inflasi:
                                      MyHelper.returnToString(f["inflasi"]) +
                                          "%",
                                  color: MyHelper.returnToString(
                                      f["warna_inflasi"]),
                                );
                              }).toList()),
                        ),
                      ],
                    ));
              },
            ),
    );

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                        _loadingMarket
                            ? "-"
                            : MyHelper.returnToString(
                                _dataFood["nama"].toString()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Container(
                      color: Colors.orange,
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: _loadingMarket
                                ? ApiService.imagePlaceholder
                                : ApiService.baseUrl +
                                    "/" +
                                    _dataFood["gambar"],
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0)
                                        .withOpacity(.6),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 40.0, horizontal: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ];
          },
          body: ListView(
            children: <Widget>[
              detail,
              SizedBox(
                height: 16.0,
              ),
              pageMarket
            ],
          )),
    );
  }
}

class _ViewHolderCommodityPrice extends StatelessWidget {
  final String date, price, status, inflasi, color;
  const _ViewHolderCommodityPrice(
      {Key? key,
      this.date = "-",
      this.price = "-",
      this.inflasi = "-",
      required this.color,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(date),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                _statusLogo(status),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  price,
                  //style: TextStyle(fontSize: MyFontSize.medium),
                ),
              ],
            ),
          ),
//          Expanded(
//            flex: 2,
//            child: Row(
//              children: <Widget>[
//                _inflasiLogo(color),
//                SizedBox(width: 8.0,),
//                Text(
//                  inflasi,
//                  //style: TextStyle(fontSize: MyFontSize.medium),
//                ),
//              ],
//            ),
//          )
        ],
      ),
    );
  }
}
