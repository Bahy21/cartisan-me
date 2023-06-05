import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeWebview extends StatefulWidget {
  final String url;

  const StripeWebview({required this.url, super.key});

  @override
  State<StripeWebview> createState() => _StripeWebviewState();
}

class _StripeWebviewState extends State<StripeWebview> {
  late String currentUrl;
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: onProgress,
          onPageStarted: (url) {
            if (url.contains('/stripe/success/')) {
              Navigator.of(context).pop(true);
            } else if (url.contains('/stripe/retry/')) {
              Navigator.of(context).pop(false);
            }
          },
          onPageFinished: onPageFinished,
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    currentUrl = widget.url;
    super.initState();
  }

  Future<void> onProgress(int progress) async {
    if (progress == 100) {
      _hideLoading();
    } else {
      _showLoading();
    }
  }

  void _showLoading() {
    if (!_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    return;
  }

  void _hideLoading() {
    if (_isLoading && mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUrl,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        centerTitle: false,
        leading: const CloseButton(),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            Positioned(
              top: 0.0,
              child: IgnorePointer(
                child: SizedBox(
                  height: 3.0,
                  width: MediaQuery.of(context).size.width,
                  child: const LinearProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void onPageFinished(String url) {
    if (mounted) {
      setState(() {
        currentUrl = url;
      });
    }
    _hideLoading();
  }
}
