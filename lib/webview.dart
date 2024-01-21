import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  late InAppWebViewController _webViewController;
  double progress = 0;

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      print('object');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (await _webViewController.canGoBack()) {
        _webViewController.goBack();
        return false;
      } else {
        return true;
      }
    },
    child: Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _showExitConfirmationDialog();
          },
        ),
        title: Text('OTT GIRL',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _webViewController.clearCache();
              _webViewController.reload();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
                content: Text("Clear Cache Successfully"),
              ));


            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse('https://ottgirl.com/'),
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  mediaPlaybackRequiresUserGesture: false,
                  supportZoom: false,
                  useShouldOverrideUrlLoading : true
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;

            },
            onLoadStop: (controller, url) async {
              setState(() {
                progress = 1.0;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              print('object');

              if (uri != null) {
                if (uri.host == 't.me' && uri.path == '/ottgirl') {
                  print('Opening Telegram link: ${uri.toString()}');
                  _launchUrl(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                } else if (uri.scheme == 'mailto') {
                  print('Opening Email link: ${uri.toString()}');
                  _launchUrl(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                } else if (uri.scheme == 'https' && uri.host == 'wa.me') {
                  print('Opening WhatsApp link: ${uri.toString()}');
                  _launchUrl(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                }else if (uri.scheme == 'https' && uri.host == 'm.me') {
                  print('Opening Email link: ${uri.toString()}');
                  _launchUrl(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                }
              }

              // If none of the conditions are met, you might want to return a different value,
              // depending on your requirements. The default here is NavigationActionPolicy.CANCEL.
              return NavigationActionPolicy.ALLOW;
            },
          ),

          LinearProgressIndicator(
            value: progress,
            color: Colors.greenAccent,
            backgroundColor: Colors.black12,
          ),
        ],
      ),
    ),
  );

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Close App"),
          content: Text("Do you want to close the app?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                _webViewController.clearCache();
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Close the app
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

}
