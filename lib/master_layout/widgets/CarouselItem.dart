import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselItem extends StatelessWidget {
  final String title;
  final String description;
  final String urlImgPlaceholder, urlImg;

  CarouselItem({
    required this.title,
    required this.description,
    required this.urlImgPlaceholder,
    required this.urlImg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
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
            errorWidget: (context, url, error) => Center(
              child: Icon(Icons.error),
            ),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0, // Adjust as needed
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0, // Adjust as needed
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
