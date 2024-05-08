import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyLayoutImage extends StatelessWidget {
  final double height, width;
  final String image;
  final BoxFit? fit;

  const MyLayoutImage(
      {Key? key,
      required this.height,
      required this.width,
      required this.image,
      this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) {
        return Center(
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: new CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Center(
          child: Icon(Icons.error),
        );
      },
      height: height,
      width: width,
      fit: fit,
      //fit: BoxFit.cover,
    );
  }
}
