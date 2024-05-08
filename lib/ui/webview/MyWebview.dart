import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWebview extends StatefulWidget {
  final String title, url;
  final String? breadcrumbs;
  MyWebview({
    Key? key,
    this.title = "",
    this.url = "",
    this.breadcrumbs,
  }) : super(key: key);

  @override
  _MyWebviewState createState() => _MyWebviewState();
}

class _MyWebviewState extends State<MyWebview> {
  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    // flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
    //   if (mounted) {
    //     setState(() {
    //       flutterWebViewPlugin.stopLoading();
    //       flutterWebViewPlugin.reloadUrl(this.widget.url);

    //       String url = error.url.toString();

    //       print("rangga str1 : " + url.indexOf("https://").toString());
    //       print("rangga str2 : " + url.indexOf("#Intent").toString());

    //       int beginChar = url.indexOf("https://");
    //       int endChar = url.indexOf("#Intent");

    //       String urlReal = url.substring(beginChar, endChar);
    //       String urlReplace = urlReal.replaceAll("%3D", "=");

    //       _launchURL(urlReplace);
    //     });
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox();
        WebviewScaffold(
      url: this.widget.url,
      appBar: new AppBar(
        title: Text(this.widget.title),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Container(
              color: MyHelper.hexToColor(MyColor.greySoft),
              height: 40.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Center(
                    child: Text(
                      this.widget.breadcrumbs ?? '',
                      style: TextStyle(fontSize: MyFontSize.medium),
                    ),
                  ),
                ],
              ),
            )),
      ),
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      resizeToAvoidBottomInset: true,
      initialChild: Center(
        child: Container(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(),
        ),
      ),
      withJavascript: true,
      //supportMultipleWindows: true,
    );
  }

  _launchURL(String urlx) async {
    String url = urlx; //--- set value
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}







//import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:pontianak_smartcity/common/MyColor.dart';
//import 'package:pontianak_smartcity/common/MyFontSize.dart';
//import 'package:pontianak_smartcity/common/MyHelper.dart';
//
//
//class MyWebview extends StatefulWidget {
//  final String title, url, breadcrumbs;
//  MyWebview({Key key, this.title = "", this.url = "", this.breadcrumbs}) : super(key: key);
//
//  @override
//  _MyWebviewState createState() => _MyWebviewState();
//}
//
//class _MyWebviewState extends State<MyWebview> {
//
//  @override
//  void initState() {
//    print(this.widget.url);
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WebviewScaffold(
//      url: this.widget.url,
//      appBar: new AppBar(
//        title: Text(this.widget.title),
//        bottom: PreferredSize(
//          preferredSize: Size.fromHeight(40.0),
//          child: Container(
//            color: MyHelper.hexToColor(MyColor.greySoft),
//            height: 40.0,
//            child: ListView(
//              padding: EdgeInsets.all(8.0),
//              scrollDirection: Axis.horizontal,
//              children: <Widget>[
//                Center(
//                  child: Text(
//                    this.widget.breadcrumbs,
//                    style: TextStyle(fontSize: MyFontSize.medium),
//                  ),
//                ),
//              ],
//            ),
//          )
//        ),
//      ),
//      withZoom: false,
//      withLocalStorage: true,
//      hidden: true,
//      resizeToAvoidBottomInset: true,
//      initialChild: Center(
//        child: Container(
//          height: 20.0,
//          width: 20.0,
//          child: CircularProgressIndicator(),
//        ),
//      ),
//    );
//  }
//
//  void loading(var status) {
//    setState(() {
//      //_isLoading = status;
//    });
//  }
//}
