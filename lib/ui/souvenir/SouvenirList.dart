import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/SPLPDApiId.dart';
import 'package:pontianak_smartcity/api/SPLPDApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyHttp.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/master_layout/MyLayoutCarousel.dart';
import 'package:pontianak_smartcity/master_layout/MyLayoutGridView.dart';
import 'package:pontianak_smartcity/master_layout/widgets/InputCari.dart';
import 'package:pontianak_smartcity/master_layout/widgets/ScrollToTop.dart';
import 'package:pontianak_smartcity/ui/hotel/HotelDetail.dart';
import 'package:pontianak_smartcity/ui/master_layout/LayoutLoading.dart';
import 'package:pontianak_smartcity/ui/souvenir/SouvenirDetail.dart';
import 'package:pontianak_smartcity/ui/tourism/TourismDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SouvenirList extends StatefulWidget {
  final String title;
  const SouvenirList({Key? key, required this.title}) : super(key: key);

  @override
  SouvenirListState createState() => SouvenirListState();
}

class SouvenirListState extends State<SouvenirList> {
  // --- variable ---
  String _category = "0";
  List _listDataCategory = [];
  var _loadingSouvenirCategory = true;

  List _listCarousel = [];
  List _listData = [];

  int _page = 1;
  bool _dataLoading = false;
  final MyHttp myHttp = MyHttp(); // ! Initial Helper Http
  final String _imgPlaceholder = SPLPDApiService.imagePlaceholder;

  final defaultTargetPlatform = TargetPlatform.android;

  TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;

  final ScrollController _scrollController = ScrollController();
  bool _isScrollToTopVisible = true;

  @override
  void initState() {
    // if you need refreshing when init,notice:initialRefresh is new  after 1.3.9
    _refreshController = RefreshController(
      initialRefresh: true,
    );

    hotelCategory();
    showData(1, "0", _category, true);

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          _isScrollToTopVisible = true;
        });
      } else {
        setState(() {
          _isScrollToTopVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    showData(1, '0', _category, true);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _page++;
    showData(_page, _searchController.text, _category, false);
    _refreshController.loadComplete();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onChange(text) {
    Timer(Duration(milliseconds: 300), () {
      setState(() {
        _page = 1;
        showData(_page, text, _category, true);
      });
    });
  }

  void _onItemTap(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SouvenirDetail(
          id: item["id"].toString(),
        ),
      ),
    );
  }

  void clearTextField() {
    _searchController.clear();
    showData(1, "0", _category, true);
  }

  @override
  Widget build(BuildContext context) {
    final _widgetCarousel = MyLayoutCarousel(
        items: _listCarousel, urlImgPlaceholder: _imgPlaceholder);

    final _widgetSearchBox = InputCari(
      searchController: _searchController,
      placeholder: MyString.search + " " + this.widget.title,
      actionPress: () {
        clearTextField();
      },
      actionChange: (text) {
        _onChange(text);
      },
    );

    final _widgetGridView = MyLayoutGridView(
      refreshController: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      scrollController: _scrollController,
      items: _listData,
      imgPlaceholder: _imgPlaceholder,
      onItemTap: _onItemTap,
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _widgetCarousel,
              SizedBox(
                height: 5,
              ),
              _widgetSearchBox,
              SizedBox(
                height: 5,
              ),
              _dataLoading ? LayoutLoading() : _widgetGridView,
            ],
          ),
          if (_isScrollToTopVisible)
            ScrollToTop(
              actionPress: _scrollToTop,
            ),
        ],
      ),
    );
  }

  // --- Method ---
  Future<String> showData(
    int page,
    String search,
    String filter,
    bool clearListParent,
  ) async {
    // setState(() {
    //   _dataLoading = true;
    // });

    var param = "/${page.toString()}/$search/$filter";

    final result = await myHttp.get(SPLPDApiService.daftartOlehOleh,
        SPLPDApiId.daftartOlehOlehApiId, param);

    List data = [];
    try {
      if (result["status"] == "success") {
        _listCarousel = result["slider"];
        data = result["data"];

        if (clearListParent) _listData.clear();

        if (data.length == 0) {
          setState(() {
            _page--;
            _refreshController.loadNoData();
          });
        } else {
          setState(() {
            _listData.addAll(data);
            _refreshController.loadComplete();
          });
        }

        _refreshController.refreshCompleted();
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
    }

    setState(() {
      _dataLoading = false;
    });

    return "Success!";
  }

  Future<String> hotelCategory() async {
    setState(() {
      _loadingSouvenirCategory = true;
    });

    final result = await myHttp.get(
        SPLPDApiService.kategoriOlehOleh, SPLPDApiId.kategoriOlehOlehApiId);

    try {
      if (result["status"] == "success") {
        _listDataCategory = result["data"];
      } else {
        MyHelper.toast(context, MyString.msgError);
      }
    } catch (e) {
      MyHelper.toast(context, MyString.msgError);
    }

    setState(() {
      _loadingSouvenirCategory = false;
    });

    return "Success!";
  }

  void _dialogCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            MyString.category,
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 300.0,
            width: double.infinity,
            child: Column(
              children: [
                Divider(),
                Container(
                  height: 250,
                  width: 400,
                  child: ListView.builder(
                    itemCount: _listDataCategory.length == 0
                        ? 1
                        : _listDataCategory.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (_listDataCategory.length != 0) {
                        return CategoryItem(
                          context,
                          (_listDataCategory.length + 1) == (index + 1)
                              ? '0'
                              : _listDataCategory[index]["id"].toString(),
                          (_listDataCategory.length + 1) == (index + 1)
                              ? '0'
                              : _listDataCategory[index]["nama_kategori"],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget CategoryItem(
      BuildContext context, String idCategory, String nameCategory) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _dataLoading = true;
              _category = idCategory != '0' ? idCategory : "0";
              String _search = _searchController.text.isNotEmpty
                  ? _searchController.text
                  : "0";
              _page = 1;
              showData(_page, _search, _category, true);
              Navigator.of(context).pop();
            });
          },
          child: ListTile(
            title: Text(nameCategory != '0' ? nameCategory : "Semua"),
          ),
        ),
        idCategory != '0' ? Divider() : Container(),
      ],
    );
  }
}
