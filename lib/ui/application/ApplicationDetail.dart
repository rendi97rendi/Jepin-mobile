import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationDetail extends StatefulWidget {
  final String name, urlPlaystore, urlWeb, imagetypography, description, color;
  const ApplicationDetail(
      {Key? key,
      required this.urlPlaystore,
      required this.urlWeb,
      required this.imagetypography,
      required this.description,
      required this.name,
      required this.color})
      : super(key: key);

  @override
  _ApplicationDetailState createState() => _ApplicationDetailState();
}

class _ApplicationDetailState extends State<ApplicationDetail> {
  _playstore() async {
    String url = this.widget.urlPlaystore; //--- set value
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL() async {
    String url = this.widget.urlWeb; //--- set value
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 3.0,
        backgroundColor: MyColor.colorAppbar,
        title: Text(
          this.widget.name,
          style: TextStyle(
              fontSize: MyFontSize.large,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: this.widget.color == false
            ? Colors.blue
            : MyHelper.hexToColor(this.widget.color),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: 50.0, bottom: 16.0, left: 30.0, right: 30.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  imageUrl: this.widget.imagetypography, //--- set value
                  placeholder: (context, url) => Center(
                      child: Container(
                    height: 20.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  )),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  "Apa itu " + this.widget.name + "?", //--- set value
                  style: TextStyle(
                      color: Colors.white, fontSize: MyFontSize.large),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: 16.0, bottom: 16.0, left: 30.0, right: 30.0),
                child: Text(
                  this.widget.description, //--- set value
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white, fontSize: MyFontSize.medium),
                ),
              ),
            ),
            this.widget.urlPlaystore == false
                ? Container()
                : InkWell(
                    onTap: () {
                      _playstore();
                    },
                    child: Center(
                      child: Container(
                        margin:
                            EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0),
                        child: Image.asset(
                          "assets/images/get_in_playstore.png", //--- set value
                          width: 140.0,
                        ),
                      ),
                    ),
                  ),
            this.widget.urlWeb == false
                ? Container()
                : Center(
                    child: Container(
                      child: TextButton(
                        onPressed: () {
                          _launchURL();
                        },
                        child: Text(
                          "Buka di browser", //--- set value
                          style: TextStyle(
                            color: Colors.orange[100],
                            fontSize: MyFontSize.medium,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
