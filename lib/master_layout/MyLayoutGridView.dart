import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/master_layout/widgets/GridItem.dart';
import 'package:pontianak_smartcity/ui/hotel/HotelDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyLayoutGridView extends StatelessWidget {
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final ScrollController scrollController;
  final List items;
  final String imgPlaceholder;
  final void Function(BuildContext context, Map<String, dynamic> item) onItemTap;

  MyLayoutGridView({
    required this.refreshController,
    required this.onRefresh,
    required this.onLoading,
    required this.scrollController,
    required this.items,
    required this.imgPlaceholder,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: defaultTargetPlatform == TargetPlatform.iOS
            ? WaterDropHeader()
            : WaterDropMaterialHeader(
                backgroundColor: Colors.orange,
              ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: GridView.builder(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                onItemTap(context, items[index]);
              },
              child: GridItem(
                image: items[index]["details"],
                name: items[index]["nama"],
                address: items[index]["alamat"],
                urlImgPlaceholder: imgPlaceholder,
                urlImg: items[index]['url_img'],
              ),
            );
          },
        ),
      ),
    );
  }
}
