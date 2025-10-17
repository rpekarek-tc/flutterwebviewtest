import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'main.dart';

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {int? windowId,
      UnmodifiableListView<UserScript>? initialUserScripts,
      PullToRefreshController? pullToRefreshController})
      : super(
            windowId: windowId,
            initialUserScripts: initialUserScripts,
            pullToRefreshController: pullToRefreshController,
            webViewEnvironment: webViewEnvironment,);

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
  }

  @override
  Future<PermissionResponse> onPermissionRequest(request) async {
    return PermissionResponse(
        resources: request.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  void onMainWindowWillClose() {
    close();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://www.google.com',
  );
  bool _useCustomUserAgent = false;
  final String _customUserAgent = "TCMobileInAppBrowser/1.0";

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _openInAppBrowser() async {
    final browser = MyInAppBrowser();

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(_urlController.text)),
      settings: InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
          toolbarTopBackgroundColor: Colors.blue,
          presentationStyle: ModalPresentationStyle.OVER_FULL_SCREEN,
        ),
        webViewSettings: InAppWebViewSettings(
          isInspectable: kDebugMode,
          allowsInlineMediaPlayback: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptCanOpenWindowsAutomatically: true,
          applicationNameForUserAgent: _useCustomUserAgent ? _customUserAgent : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebView Demo'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter URL:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter URL',
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text('Use Custom User Agent'),
                subtitle: Text(_customUserAgent),
                value: _useCustomUserAgent,
                onChanged: (bool? value) {
                  setState(() {
                    _useCustomUserAgent = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Choose a browser option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/InAppWebView',
                    arguments: {
                      'url': _urlController.text,
                      'useCustomUserAgent': _useCustomUserAgent,
                      'customUserAgent': _customUserAgent,
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text('Open InApp WebView'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _openInAppBrowser,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text('Open InApp Browser'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}