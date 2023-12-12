// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, prefer_const_constructors, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:pluspoint/util/constants.dart' as constants;
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// #enddocregion platform_imports

// void main() => runApp(const MaterialApp(home: CertificateResult()));

class CertificateResult extends StatefulWidget {
  // const CertificateResult({super.key});
  final int? studentIdData;
  final String? courseIdData;

  const CertificateResult(
      {required this.studentIdData, required this.courseIdData});

  @override
  State<CertificateResult> createState() => _CertificateResultState();
}

class _CertificateResultState extends State<CertificateResult> {
  late final WebViewController _controller;
  late final ScreenshotController screenshotController = ScreenshotController();
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();

    final student_id = widget.studentIdData; // Access student_id here
    final course_id = widget.courseIdData; // Access student_id here

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features
    // print(student_id);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
          onPageFinished: (String url) {
            Navigator.pop(context);

            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
                '''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(
          '${constants.project_url}/student/viewcertificate?student_id=$student_id&course_id=$course_id&web=1'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      // AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: constants.mainColor,
        foregroundColor: Colors.white,
        title: const Text('Certificate'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        // actions: <Widget>[
        //   NavigationControls(webViewController: _controller),
        //   SampleMenu(webViewController: _controller),
        // ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await captureScreenshotAndConvertToPDF(); // Call the printCertificate method
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
      body: Screenshot(
          controller: screenshotController,
          child: WebViewWidget(controller: _controller)),
      // floatingActionButton: favoriteButton(),
    );
  }

  Future<void> captureScreenshotAndConvertToPDF() async {
    // Capture a screenshot of the web page

    await Future.delayed(Duration(milliseconds: 500));
    final imageFile = await screenshotController.capture();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(imageFile!));
        },
      ),
    );

    final pdfFile = await pdf.save();

    await Printing.sharePdf(bytes: pdfFile);
  }
}
