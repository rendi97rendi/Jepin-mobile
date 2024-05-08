import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pontianak_smartcity/common/MyColor.dart';
import 'package:pontianak_smartcity/common/MyFontSize.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewWebView extends StatefulWidget {
  final String title, url, breadcrumbs;
  NewWebView({
    this.title = "",
    this.url = "",
    required this.breadcrumbs,
  });
  @override
  _NewWebViewState createState() => _NewWebViewState();
}

class _NewWebViewState extends State<NewWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
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
                      widget.breadcrumbs,
                      style: TextStyle(fontSize: MyFontSize.medium),
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        // onPageStarted: (val) {
        //   print('onPageStarted : $val');
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // },
      ),
    );
  }
}
