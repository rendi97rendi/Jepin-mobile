import 'package:flutter/foundation.dart';

class MarkerModel {
  int id;
  String nama;
  String alamat;
  double latitude;
  double longitude;
  String url;
  bool status;
  MarkerCategory? category;

  MarkerModel({
    required this.id,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.nama,
    required this.status,
    required this.url,
    this.category,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
        id: json['id'] as int,
        alamat: json['address'] as String,
        latitude: double.parse(json['latitude'] as String),
        longitude: double.parse(json['longitude'] as String),
        nama: json['name'] as String,
        status: json['status'] == 1 ? true : false,
        url: json['url'] as String,
        category: json['category'] != null
            ? MarkerCategory.fromJson(json['category'])
            : null,
      );
}

class MarkerCategory {
  int id;
  String nama;
  String iconUrl;

  MarkerCategory({
    required this.id,
    required this.nama,
    required this.iconUrl,
  });

  factory MarkerCategory.fromJson(Map<String, dynamic> json) => MarkerCategory(
        id: json['id'] as int,
        nama: json['name'] as String,
        iconUrl: json['icon_file'] as String,
      );
}
