import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final ChewieController chewieController;
  final String title;

  VideoPlayerScreen({required this.chewieController, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: chewieController != null
          ? Container(
              width: size.width,
              height: double.infinity,
              child: Chewie(controller: chewieController),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
