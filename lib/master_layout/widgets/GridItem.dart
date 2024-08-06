import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final List image;
  final String name, address, urlImgPlaceholder, urlImg;

  const GridItem({
    Key? key,
    required this.image,
    required this.name,
    required this.address,
    required this.urlImgPlaceholder,
    this.urlImg = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    // Menentukan ukuran font dinamis
    final double nameFontSize = screenWidth * 0.035;
    final double addressFontSize = screenWidth * 0.025;

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: CachedNetworkImage(
              imageUrl: urlImg.isEmpty ? urlImgPlaceholder : urlImg,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: nameFontSize,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow
                      .ellipsis, // Memotong teks yang terlalu panjang
                ),
                SizedBox(height: 8.0),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: addressFontSize,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow
                      .ellipsis, // Memotong teks yang terlalu panjang
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
