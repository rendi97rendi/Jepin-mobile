import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/master_layout/widgets/CarouselItem.dart';

class MyLayoutCarousel extends StatelessWidget {
  final List items;
  final String urlImgPlaceholder;

  MyLayoutCarousel({
    required this.items,
    required this.urlImgPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        aspectRatio: 2.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 1000),
        enlargeCenterPage: false,
      ),
      items: items.isEmpty
          ? [
              CarouselItem(
                  title: '',
                  description: '',
                  urlImgPlaceholder: urlImgPlaceholder,
                  urlImg: '')
            ]
          : items.map((item) {
              return CarouselItem(
                urlImgPlaceholder: urlImgPlaceholder,
                urlImg: item["url_img"] ?? urlImgPlaceholder,
                title: item["judul"] ?? '',
                description: item["keterangan"] ?? '',
              );
            }).toList(),
    );
  }
}
