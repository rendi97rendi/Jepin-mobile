import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';
import 'package:pontianak_smartcity/ui/telepon/teleponItem.dart';
import 'package:toast/toast.dart';

class TeleponScreen extends StatefulWidget {
  @override
  _TeleponScreenState createState() => _TeleponScreenState();
}

class _TeleponScreenState extends State<TeleponScreen> {
  bool _isLoading = false;
  var _dataTelepon = [];
  var _filterData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void filterData(String q) {
    // _dataTelepon = _newData;
    var _telp = [];
    _telp.addAll(_dataTelepon);

    if (q.isNotEmpty) {
      _filterData = _telp
          .where(
            (item) =>
                item['nama'].toString().toLowerCase().contains(
                      q.toLowerCase(),
                    ) ||
                item['no_telp'].contains(q) ||
                item['alamat'].toString().toLowerCase().contains(q),
          )
          .toList();
      setState(() {});
    } else {
      _filterData = _dataTelepon;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.bgColor,
        appBar: AppBar(
          title: Text('Telepon Penting'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
              elevation: 0.0,
              margin: EdgeInsets.all(16),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: MyString.search,
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (q) {
                    filterData(q);
                  },
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filterData.length,
                      itemBuilder: (context, i) {
                        return TeleponItem(
                          nama: _filterData[i]['nama'],
                          alamat: _filterData[i]['alamat'],
                          nomor: _filterData[i]['no_telp'],
                        );
                      },
                    ),
                  ),
          ],
        ));
  }

  Future<String> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    var response = await http.get(Uri.parse(ApiService.teleponPenting),
        headers: {"Accept": "application/json"});
    print('onFetchData : fetching data...');
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        var result = json.decode(response.body);
        List? data;
        if (result['data'] != null) {
          data = result["data"];
          print('onFetchData : data collected...');
          _dataTelepon.clear();
        }

        if (data != null) {
          _dataTelepon = data;
          print('onFetchData : ' + _dataTelepon.toString());
          _filterData = _dataTelepon;
        }

        _isLoading = false;
      });
    } else {
      MyHelper.toast(context, MyString.msgError);
    }

    return "Success!";
  }
}
