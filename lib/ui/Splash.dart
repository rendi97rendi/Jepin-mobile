import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/ui/dashboard/Dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  late AnimationController animationController2;
  late Animation<Offset> animation2;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ));
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    animationController2 =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation2 = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(animationController2);
    animationController2.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            // Positioned(
            //   top: -20.0,
            //   left: -15.0,
            //   child: Opacity(
            //     opacity: .3,
            //     child: Image(
            //       image: AssetImage("assets/images/paper_party.png"),
            //       width: MediaQuery.of(context).size.width + 30.0,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: 72.0,
            //   left: 32.0,
            //   child: Image.asset(
            //     'assets/images/splash_image1.png',
            //     width: 250.0,
            //   ),
            // ),
            //--- Logo ---
            Center(
              child: Image.asset(
                'assets/icon/logo_landscape.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ),
            //--- Logo ---
            // SlideTransition(
            //   position: animation2,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Image.asset(
            //       'assets/images/splash_image2.png',
            //       width: MediaQuery.of(context).size.width,
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
