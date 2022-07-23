import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Webview extends StatefulWidget {

  String url = "";
  Webview({Key? key,required this.url}) : super(key: key);
  //Webview({@required this.url});
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  bool _isLoading = true;
  late String urltest;


  @override
  void initState() {
    super.initState();
    urlview();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void urlview() {
    setState(() {
      urltest = "${widget.url}";
    });
  }




  late InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    Color currentColor = Colors.yellow;
    return Scaffold(
      appBar: appbarwidget(),
      body: Container(
          child: InAppWebView(

            initialUrlRequest:
            URLRequest(url: Uri.parse(urltest)),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    cacheEnabled: true,
                    clearCache: false,
                    javaScriptEnabled: true,
                    verticalScrollBarEnabled: true,
                    horizontalScrollBarEnabled: true,
                    supportZoom: true,
                    useShouldOverrideUrlLoading: false
                )
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onLoadStart: (InAppWebViewController controller, urltest){

            },
            onLoadStop: (InAppWebViewController controller, urltest){
              pageFinishedLoading("abc");
            },
            onLoadError: (InAppWebViewController controller,
                urltest, int i, String s)async{
              _webViewController.loadFile(assetFilePath: "assets/images/error.html");
              Fluttertoast.showToast(msg: "Please Check Your Internect Connection",textColor: Colors.red,backgroundColor: Colors.white);
            },
            onLoadHttpError: (InAppWebViewController controller,urltest,int i ,String s){
              _webViewController.loadFile(assetFilePath: "assets/images/error.html")  ;
              Fluttertoast.showToast(msg: "Please Check Your Internect Connection",textColor: Colors.red,backgroundColor: Colors.white);
            },



          )

      ),
    );
  }

  void pageFinishedLoading(String url) {
    setState(() {
      _isLoading = false;
    });
  }
}