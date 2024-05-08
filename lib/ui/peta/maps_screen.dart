import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pontianak_smartcity/api/ApiService.dart';
import 'package:pontianak_smartcity/model/markerModel.dart';
import 'package:pontianak_smartcity/ui/peta/map_widget.dart';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:pontianak_smartcity/ui/peta/video_player_screen.dart';
import 'package:video_player/video_player.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Set<Marker> _markers = Set();
  List<MarkerModel> dataMarkers = [];

  List<MarkerCategory> _categories = [];
  bool _isLoading = false;
  //Property Google Map Controller completer
  Completer<GoogleMapController> _completer = Completer();
  Completer<GoogleMapController> get completer => _completer;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  List<MarkerCategory> _selectedCategories = [];

  //Property Google Map Controller
  GoogleMapController? _controller;
  GoogleMapController? get controller => _controller;

  String? _mapStyle;

  MarkerModel? _selectedMarker;

  @override
  void initState() {
    loadMapStyle();
    super.initState();
  }

  @override
  void dispose() {
    if (videoPlayerController != null) {
      videoPlayerController?.dispose();
    }

    if (chewieController != null) {
      chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _showMaterialDialog() async {
      await FilterListDialog.display<MarkerCategory>(context,
          hideSearchField: true,
          borderRadius: 8,
          listData: _categories,
          selectedListData: _selectedCategories,
          height: size.height * 0.5,
          headlineText: "Filter",
          themeData: FilterListThemeData(
            context,
            // controlButtonBarTheme: ControlButtonBarThemeData(
            //   controlButtonTheme: ControlButtonThemeData(
            //       primaryButtonBackgroundColor: Colors.orange,
            //       textStyle: TextStyle(color: Colors.orange)),
            // ),
          ),
          backgroundColor: Colors.orange,
          // controlButtonTextStyle: TextStyle(color: Colors.orange, fontSize: 15),
          // applyButtonTextStyle: TextStyle(color: Colors.white, fontSize: 15),
          choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: isSelected == true ? Colors.orange[300] : Colors.grey[300],
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            item.nama,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      },

          // searchFieldHintText: "Search Here",
          choiceChipLabel: (item) {
        return item?.nama;
      }, validateSelectedItem: (list, val) {
        return list?.contains(val) ?? false;
      }, onItemSearch: (list, text) {
        return true;
        // if (list.any((element) =>
        //     element.nama.toLowerCase().contains(text.toLowerCase()))) {
        //   return list
        //       .where((element) =>
        //           element.nama.toLowerCase().contains(text.toLowerCase()))
        //       .toList();
        // } else {
        //   return [];
        // }
      }, onApplyButtonClick: (list) async {
        if (list != null) {
          _selectedCategories = list;
          _markers.clear();
          // _filteredMarkers = dataMarkers.where((element) {
          //   list.forEach((item) {
          //     if (item.id == element.category.id) {
          //       return true;
          //     }
          //   });
          //   return false;
          // }).toList();

          dataMarkers.forEach((x) {
            _selectedCategories.forEach((y) async {
              if (x.category?.id == y.id) {
                var markerIcon = await getMarkerImageFromUrl(
                    'http://alpha3.pontive.web.id/images/icons/' +
                        x.category!.iconUrl,
                    targetWidth: 120);
                setState(() {});

                _markers.add(Marker(
                    markerId: MarkerId(x.id.toString()),
                    position: LatLng(x.latitude, x.longitude),
                    icon: markerIcon,
                    onTap: () {
                      _selectedMarker = x;
                      setState(() {});
                    }));
              }
            });
          });
          _selectedMarker = null;
          setState(() {});
        }
        Navigator.pop(context);
      });
      // showDialog(
      //     context: context,
      //     builder: (_) => StatefulBuilder(
      //           builder: (context, setState) => AlertDialog(
      //             title: Text(
      //               "Filter Kategori",
      //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      //             ),
      //             content: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Wrap(
      //                   children: _categories
      //                       .map((item) => Container(
      //                           margin: EdgeInsets.only(right: 10),
      //                           child: GestureDetector(
      //                             onTap: () {},
      //                             child: Chip(
      //                                 backgroundColor: Colors.orange,
      //                                 padding: EdgeInsets.symmetric(
      //                                     vertical: 4, horizontal: 6),
      //                                 label: Text(
      //                                   item.nama,
      //                                   style: TextStyle(
      //                                       fontSize: 14, color: Colors.white),
      //                                 )),
      //                           )))
      //                       .toList(),
      //                 )
      //               ],
      //             ),
      //             actions: <Widget>[],
      //           ),
      //         ));
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
            width: size.width,
            height: size.height,
            child: MapWidget(
              markers: _markers,
              onMapCreated: onMapCreated,
            )),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 10.0),
                        blurRadius: 10.0,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                margin: EdgeInsets.all(16),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        _showMaterialDialog();
                      },
                child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    margin: EdgeInsets.all(16),
                    child: _isLoading
                        ? Container(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Filter')
                            ],
                          )),
              ),
            ],
          ),
        ),
        _selectedMarker != null
            ? SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: _selectedMarker?.category?.id == 1
                        ? () async {
                            videoPlayerController =
                                VideoPlayerController.network(
                                    _selectedMarker!.url);

                            chewieController = ChewieController(
                                videoPlayerController: videoPlayerController!,
                                autoPlay: true,
                                aspectRatio: 16 / 9);
                            setState(() {});

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                title: _selectedMarker?.nama ?? '',
                                chewieController: chewieController!,
                              ),
                            ));
                          }
                        : null,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32, left: 16, right: 16),
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              child: Image.network(
                                  'http://alpha3.pontive.web.id/images/icons/' +
                                      _selectedMarker!.category!.iconUrl),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedMarker!.nama,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    _selectedMarker!.alamat,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            _selectedMarker!.category?.id == 1
                                ? Row(
                                    children: [
                                      Text('Putar'),
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    ));
  }

  //Function to handle when maps created
  void onMapCreated(GoogleMapController controller) async {
    _completer.complete(controller);
    _controller = controller;

    //Set style to map
    _controller?.setMapStyle(_mapStyle);
    loadMarkers();

    setState(() {});
  }

  void setMarkers(List<MarkerModel> data) async {
    if (data == null) {
      return;
    }

    data.forEach((item) async {
      ///Create marker point
      var markerIcon = await getMarkerImageFromUrl(
          'http://alpha3.pontive.web.id/images/icons/' + item.category!.iconUrl,
          targetWidth: 120);
      setState(() {});

      _markers.add(Marker(
          markerId: MarkerId(item.id.toString()),
          position: LatLng(item.latitude, item.longitude),
          icon: markerIcon,
          onTap: () {
            _selectedMarker = item;
            setState(() {});
          }));
    });
  }

  void loadMarkers() async {
    // print('load Markers');
    setState(() {
      _isLoading = true;
    });
    var response = await http.get(
      Uri.parse(ApiService.map),
      headers: {"Accept": "application/json"},
    );

    // print(response);

    List<MarkerModel> data = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      var result = json.decode(response.body);
      if (result['status']) {
        (result['data']['maps'] as List<dynamic>).forEach((element) {
          data.add(MarkerModel.fromJson(element));
        });
        _categories = List<MarkerCategory>.from(
            result['data']['category'].map((x) => MarkerCategory.fromJson(x)));
        dataMarkers = data;
        _selectedCategories = _categories;
        // print(data);
      }
    }

    setMarkers(dataMarkers);
    setState(() {
      _isLoading = false;
    });
  }

  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    int? targetWidth,
  }) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    if (targetWidth != null) {
      markerImageBytes = await _resizeImageBytes(
        markerImageBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  void loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/styles/map_style.txt');
  }

  static Future<Uint8List> _resizeImageBytes(
    Uint8List imageBytes,
    int targetWidth,
  ) async {
    final ui.Codec imageCodec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

    final data =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }
}
