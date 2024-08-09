import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/api/SPLPDApiId.dart';
import 'package:pontianak_smartcity/api/SPLPDApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/common/MyHttp.dart';
import 'package:pontianak_smartcity/common/MyShimmer.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/dashboard/Menu.dart';
import 'package:pontianak_smartcity/ui/food_info/FoodInfo.dart';
import 'package:pontianak_smartcity/ui/news/NewsDetail.dart';
import 'package:pontianak_smartcity/ui/peta/maps_screen.dart';
import 'package:pontianak_smartcity/ui/search/Search.dart';
import 'package:pontianak_smartcity/ui/telepon/telepon.dart';
import 'package:pontianak_smartcity/ui/webview/MyWebview.dart';
import 'package:pontianak_smartcity/ui/webview/NewWebView.dart';
import 'package:toast/toast.dart';

var _dataSetting;

List listCarousel = [];
Color colorNav = Colors.orange;

List _dataBerita = [];
List _dataMenu = [];
List _dataSmartMenu = [];
var _isLoading = true;
int _current = 0;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class HomeScreen extends StatefulWidget {
  final Function callback;

  HomeScreen({required this.callback});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MyHttp myHttp = MyHttp(); // ! Initial Helper Http
  final String _imgPlaceholder = SPLPDApiService.imagePlaceholder;
  String _logoApps = SPLPDApiService.imagePlaceholder;

  @override
  void initState() {
    showCarousel();
    showMenu();
    showSetting();
    showNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _widgetCarousel = _isLoading
        ? Container(
            padding: EdgeInsets.all(30),
            child: roundedShimmer(
              height: 200,
              width: size.width * 0.8,
              borderRadius: 16,
            ),
          )
        : Column(children: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MapsScreen()));
            //   },
            //   child: Text('Buka Maps'),
            // ),
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
                        image: _imgPlaceholder,
                        title: "Pontianak Kote Tercinte",
                        subtitle:
                            "Kecik telapak tangan, Nyirok pon kamek tadahkan",
                      ),
                      _ViewHolderCarousel(
                        image: _imgPlaceholder,
                        title: "Pontianak Smartcity",
                        subtitle: "Awak datang, kamek sambot",
                      ),
                    ]
                  : listCarousel.map((f) {
                      return _ViewHolderCarousel(
                        image: f["url_foto"],
                        title: f["judul"],
                        subtitle: f["keterangan"] ?? '',
                        url: f['url'] ?? null,
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
                          ? Colors.orange
                          : Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                  );
                },
              ),
            ),
          ]);

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

    final _berita = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Berita Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () => widget.callback(2),
                child: Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 320.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dataBerita.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading)
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewsDetail(
                                id: _dataBerita[index]['id'],
                              )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: 280.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            width: 280.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, -2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: 80.0),
                                  Text(
                                    _dataBerita[index]['judul_berita'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5.0), // Increased space
                                  Text(
                                    DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                                        .format(
                                      DateTime.parse(
                                          _dataBerita[index]['tanggal_berita']),
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color:
                                          Colors.grey[700], // Dark grey color
                                    ),
                                  ),
                                  SizedBox(height: 10.0), // Space below date
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CachedNetworkImage(
                              height: 180.0,
                              width: 260.0,
                              imageUrl: 'https://pontianak.go.id/file/berita/' +
                                  jsonDecode(
                                      _dataBerita[index]['img_berita'])[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              return Container(
                padding: EdgeInsets.all(10),
                child:
                    roundedShimmer(width: 280, height: 100, borderRadius: 10),
              );
            },
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16.0, bottom: 16.0, left: 16.0),
                        child: FancyShimmerImage(
                          imageUrl: _logoApps,
                          boxFit: BoxFit.fitWidth,
                          width: 120,
                          height: 60.0,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    child: _widgetCarousel,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      // bottom: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Smart City',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _isLoading
                                ? 6
                                : _dataSmartMenu == null
                                    ? 0
                                    : _dataSmartMenu.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1 / 1.28,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (!_isLoading)
                                return MenuSmartItem(
                                  title: _dataSmartMenu[index]["menu"]["label"]
                                      .toString(),
                                  icon: MyHelper.replaceBaseUrl(
                                      _dataSmartMenu[index]["menu"]
                                          ["android_icon"]),
                                  index: index,
                                );
                              return Container(
                                child: Column(
                                  children: [
                                    roundedShimmer(
                                        width: 64,
                                        height: 64,
                                        borderRadius: 30),
                                    SizedBox(height: 10),
                                    textShimmer(width: 40, height: 15),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'More',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _isLoading
                                ? 6
                                : _dataMenu == null
                                    ? 0
                                    : _dataMenu.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              childAspectRatio: 1 / 1.39,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (!_isLoading)
                                return MenuItem(
                                  title: _dataMenu[index]["menu"]["label"]
                                      .toString(),
                                  icon: MyHelper.replaceBaseUrl(
                                      _dataMenu[index]["menu"]["android_icon"]),
                                  index: index,
                                  callback: widget.callback,
                                );
                              return Container(
                                child: Column(
                                  children: [
                                    roundedShimmer(
                                        width: 64,
                                        height: 64,
                                        borderRadius: 30),
                                    SizedBox(height: 10),
                                    textShimmer(width: 40, height: 15),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _berita,
          _widgetFooter
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //   color: Colors.white,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [],
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<String> showCarousel() async {
    try {
      final result =
          await myHttp.get(SPLPDApiService.carousel, SPLPDApiId.carouselApiId);
      setState(() {
        if (result["status"] == "success") {
          listCarousel = result["data"];
        }
      });
    } catch (e) {
      MyHelper.toast(context, e.toString());
    }
    return "Success!";
  }

  Future<String> showSetting() async {
    final result =
        await myHttp.get(SPLPDApiService.setting, SPLPDApiId.settingApiId);
    try {
      if (result["status"] == "success") {
        _dataSetting = result["data"];

        setState(() {
          _dataSetting == null
              ? _logoApps
              : _logoApps = _dataSetting["url_logo_apps"];
        });
      }
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
    }
    return "Success!";
  }

  Future<String> showNews() async {
    setState(() {
      _isLoading = true;
    });

    final result = await myHttp.get(
        SPLPDApiService.beritaTerbaru, SPLPDApiId.beritaTerbaruApiId);
    try {
      setState(() {
        if (result["status"] == true) {
          _dataBerita = result["data"];
          // print(_dataBerita);
        }
        _isLoading = false;
      });
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
      ;
    }

    return "Success!";
  }

  Future<String> showMenu() async {
    setState(() {
      _isLoading = true;
    });

    final result = await myHttp.get(
        SPLPDApiService.menuSmartcity, SPLPDApiId.menuSmartcityApiId);
    try {
      setState(() {
        List menu = [];
        if (result["status"] == "success") {
          menu = result["data"];
          _dataSmartMenu.clear();
          _dataMenu.clear();
        }

        menu.forEach((e) {
          if (e['menu']['label'].toString().contains('Smart')) {
            _dataSmartMenu.add(e);
          } else {
            _dataMenu.add(e);
          }
        });

        // _dataMenu.removeWhere(
        //   (e) => e['menu']['label'].toString().contains('Lapor'),
        // );

        // print(_dataSmartMenu);

        _isLoading = false;
      });
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }
}

class _ViewHolderCarousel extends StatelessWidget {
  final String image, title, subtitle;
  final String? url;
  const _ViewHolderCarousel({
    Key? key,
    this.image = "",
    this.title = "",
    this.subtitle = "",
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewWebView(
                title: title,
                url: url!,
                breadcrumbs: '',
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: Stack(children: <Widget>[
            FancyShimmerImage(
                imageUrl: image,
                // placeholder: (context, url) => Center(
                //         child: Container(
                //       height: 20.0,
                //       width: 20.0,
                //       child: CircularProgressIndicator(),
                //     )),
                // errorWidget: (context, url, error) => Center(
                //       child: Icon(Icons.error),
                //     ),
                boxFit: BoxFit.cover,
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
                      title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
      ),
    );
  }
}

// More
class MenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final int index;
  final Function callback;

  MenuItem(
      {required this.title,
      required this.icon,
      required this.index,
      required this.callback});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List data = _dataMenu[this.index]["list"];

        if (_dataMenu[index]["menu"]["id"] == 158) {
          //open Harga Komoditas
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodInfo(),
            ),
          );
        } else if (_dataMenu[index]['menu']['id'] == 164) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeleponScreen(),
            ),
          );
        } else if (_dataMenu[index]['menu']['id'] == 294) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapsScreen()));
        } else if (_dataMenu[index]['menu']['id'] == 160) {
          callback(2);
        } else {
          if (data.length == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewWebView(
                  title: _dataMenu[index]["menu"]["label"],
                  url: _dataMenu[index]["menu"]["link"],
                  breadcrumbs: _dataMenu[index]["menu"]["label"],
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Menu(
                  title: title,
                  data: _dataMenu,
                  dataList: _dataMenu[this.index]["list"],
                ),
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: CachedNetworkImage(imageUrl: icon),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class MenuSmartItem extends StatelessWidget {
  final String title;
  final String icon;
  final int index;

  MenuSmartItem({required this.title, required this.icon, required this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List data = _dataSmartMenu[this.index]["list"];

        if (_dataSmartMenu[index]["menu"]["id"] == 158) {
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
                builder: (context) => NewWebView(
                  title: _dataSmartMenu[index]["menu"]["label"],
                  url: _dataSmartMenu[index]["menu"]["link"],
                  breadcrumbs: _dataSmartMenu[index]["menu"]["label"],
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Menu(
                  title: title,
                  data: _dataSmartMenu,
                  dataList: _dataSmartMenu[this.index]["list"],
                ),
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: CachedNetworkImage(
              imageUrl: icon,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
