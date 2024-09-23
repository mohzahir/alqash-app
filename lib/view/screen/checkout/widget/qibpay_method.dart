import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QIBPayMethod extends StatelessWidget {
  const QIBPayMethod({Key? key, required this.amount}) : super(key: key);
  final double amount;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> formData = {
      'action': 'capture',
      'gatewayId': '019856927',
      'signatureFields': 'gatewayId,amount,referenceId',
      'signature': '51VIvVbFvw4QBi+VnsyibOtd+YgVwIm/L/MFz3gm0s0=',
      'referenceId': 'ORDER17069654009936',
      'amount': '$amount',
      'currency': 'QAR',
      'mode': 'LIVE',
      'description': 'PRODUCT_DESC',
      'returnUrl': 'https://alqash.dev.tqnia.me/payment/callback',
      'name': 'ahmed',
      'address': 'gggg',
      'city': 'vvvvv',
      'state': 'vnmbvb',
      'country': 'QA',
      'phone': '0987654334',
      'email': 'ys@mail.com',
    };
    final Uri paymentApiUrl =
        Uri.parse('https://paymentapi.qib.com.qa/api/gateway/v2.0');

    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: false,
        onWebResourceError: (error) {
          debugPrint(error.domain);
        },
        zoomEnabled: true,
        backgroundColor: Colors.transparent,
        onWebViewCreated: (controller) {
          controller.loadRequest(
            WebViewRequest(
              uri: paymentApiUrl,
              method: WebViewRequestMethod.post,
              body: Uint8List.fromList(utf8.encode(mapToQueryString(formData))),
            ),
          );
        },
        onPageFinished: (url) {
          print(url);
        },
      ),
      // body: InAppWebView(
      //   initialUrlRequest: URLRequest(
      //       url: paymentApiUrl,
      //       method: 'POST',
      //       body: Uint8List.fromList(utf8.encode(mapToQueryString(formData))),
      //       headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      //   onWebViewCreated: (controller) {},
      //   onLoadStop: (controller, url) {
      //     print(url.toString());
      //   },
      // ),
      // body: FutureBuilder(
      //     future: Provider.of<QIBPayProvider>(context).pay(amount: amount),
      //     builder: (context, snapshot) {
      //       print(snapshot.data.runtimeType);
      //       if (snapshot.connectionState == ConnectionState.done &&
      //           snapshot.data != null) {
      //         // print(snapshot.data['redirect_url']);
      //         return CardsFrameView(
      //           url: snapshot.data.toString(),
      //           onPaymetCompleted: (id) {},
      //         );
      //       }
      //       return const Center(child: CircularProgressIndicator());
      //     }),
    );
  }
}

String mapToQueryString(Map<String, dynamic> map) {
  List<String> pairs = [];
  map.forEach((key, value) {
    pairs.add(
        Uri.encodeComponent(key) + '=' + Uri.encodeComponent(value.toString()));
  });
  return pairs.join('&');
}
