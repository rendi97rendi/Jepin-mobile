import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/food_info/FoodInfo.dart';
import 'package:pontianak_smartcity/ui/search/Search.dart';
import 'package:pontianak_smartcity/ui/webview/MyWebview.dart';
import 'package:toast/toast.dart';
import 'Menu.dart';
import 'package:flutter/rendering.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';

var _dataSetting;

List listCarousel = [];
Color colorNav = Colors.orange;

List _dataMenu = [];
var _isLoading = true;
int _current = 0;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class SmartCity extends StatefulWidget {
  @override
  _SmartCityState createState() => _SmartCityState();
}

class _SmartCityState extends State<SmartCity> {
  String _logoApps = ApiService.imagePlaceholder;

  @override
  void initState() {
    showSetting();
    showCarousel();
    showMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //--- Widget ---

    final _widgetSearchBox = Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            );
          },
          decoration: InputDecoration(
            hintText: MyString.dshSearch,
            hintStyle: TextStyle(color: Colors.white30),
            icon: Icon(Icons.search, color: Colors.white30),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    final _widgetCarousel = Column(children: [
      CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, _) {
            setState(() {
              _current = index;

              colorNav = listCarousel.length == 0
                  ? MyHelper.hexToColor("#24446f")
                  : MyHelper.hexToColor(listCarousel[index]["warna"]);
            });
          },
        ),
        items: listCarousel.length == 0
            ? <Widget>[
                _ViewHolderCarousel(
                  image: ApiService.imagePlaceholder,
                  title: "Pontianak Kote Tercinte",
                  subtitle: "Kecik telapak tangan, Nyirok pon kamek tadahkan",
                ),
                _ViewHolderCarousel(
                  image: ApiService.imagePlaceholder,
                  title: "Pontianak Smartcity",
                  subtitle: "Awak datang, kamek sambot",
                ),
              ]
            : listCarousel.map((f) {
                return _ViewHolderCarousel(
                  image: f["url_foto"],
                  title: f["judul"],
                  subtitle: f["keterangan"],
                );
              }).toList(),
      ),
      // --- Dot Carousel ---
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          listCarousel,
          (index, i) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 2.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          },
        ),
      ),
    ]);

    final _widgetHeader = Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          //--- Background ---
          AnimatedContainer(
            margin: EdgeInsets.all(0.0),
            duration: Duration(seconds: 2),
            child: Container(
              height: 330.0,
            ),
            decoration: BoxDecoration(
              color: colorNav,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80.0),
                bottomRight: Radius.circular(80.0),
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 16.0),
                  child: Image.network(
                    _logoApps,
                    fit: BoxFit.fitWidth,
                    height: 60.0,
                  ),
                ),
                _widgetSearchBox,
                SizedBox(
                  height: 16.0,
                ),
                _widgetCarousel,
              ],
            ),
          ),
        ],
      ),
    );

    final _widgetMenu = Container(
      margin: EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
          ),
          _isLoading
              ? Center(
                  child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ))
              : GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _dataMenu == null ? 0 : _dataMenu.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _ViewHolderSmartCity(
                      title: _dataMenu[index]["menu"]["label"].toString(),
                      icon: MyHelper.replaceBaseUrl(
                          _dataMenu[index]["menu"]["android_icon"]),
                      index: index,
                    );
                  }),
        ],
      ),
    );

    final _widgetFooter = Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          _dataSetting == null
              ? ""
              : MyHelper.returnToString(_dataSetting["copyright"]),
          style: TextStyle(color: Colors.black26),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _widgetHeader,
          _widgetMenu,
          _widgetFooter,
        ],
      ),
    );
  }

  Future<String> showSetting() async {
    var response = await http.get(Uri.parse(ApiService.setting),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        var result = json.decode(response.body);

        if (result["status"] == "success") {
          _dataSetting = result["data"];

          setState(() {
            _dataSetting == null
                ? _logoApps = ApiService.imagePlaceholder
                : _logoApps = ApiService.baseUrl2 + _dataSetting["logo_web"];
          });
        }
      });
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }

  Future<String> showCarousel() async {
    var response = await http.get(Uri.parse(ApiService.carousel),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        var result = json.decode(response.body);

        if (result["status"] == "success") {
          listCarousel = result["data"];
        }
      });
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }

  Future<String> showMenu() async {
    setState(() {
      _isLoading = true;
    });

    var response = await http.get(Uri.parse(ApiService.homeMenu),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        var result = json.decode(response.body);

        if (result["status"] == "success") {
          _dataMenu = result["data"];
        }

        _isLoading = false;
      });
    } else {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }
}

// --- View Holder ---

class _ViewHolderCarousel extends StatelessWidget {
  final String image, title, subtitle;
  const _ViewHolderCarousel(
      {Key? key, this.image = "", this.title = "", this.subtitle = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        child: Stack(children: <Widget>[
          CachedNetworkImage(
              imageUrl: image,
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
              width: 1000.0),
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MyFontSize.large,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    subtitle ?? "",
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
      ),
    );
  }
}

class _ViewHolderSmartCity extends StatelessWidget {
  final String title, icon;
  final int index;
  _ViewHolderSmartCity(
      {required this.title, required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List data = _dataMenu[this.index]["list"];

        if (_dataMenu[index]["menu"]["id"] == 179) {
          //open Harga Komoditas
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodInfo(),
            ),
          );
        } else {
          if (data.length == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyWebview(
                        title: _dataMenu[index]["menu"]["label"],
                        url: _dataMenu[index]["menu"]["link"],
                        breadcrumbs: _dataMenu[index]["menu"]["label"],
                      )),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Menu(
                        title: title,
                        data: _dataMenu,
                        dataList: _dataMenu[this.index]["list"],
                      )),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              imageUrl: icon,
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
          ),
        ],
      ),
    );
  }
}
