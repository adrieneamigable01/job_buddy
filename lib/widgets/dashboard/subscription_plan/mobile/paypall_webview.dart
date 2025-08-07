import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebViewPage extends StatefulWidget {
  final String approvalUrl;

  const PaypalWebViewPage({Key? key, required this.approvalUrl}) : super(key: key);

  @override
  State<PaypalWebViewPage> createState() => _PaypalWebViewPageState();
}

class _PaypalWebViewPageState extends State<PaypalWebViewPage> {
  late final WebViewController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            debugPrint('Loading: $url');
            setState(() => isLoading = true);

            // You can customize this based on your PayPal return/cancel URLs
            if (url.contains('paypal/subscription/success')) {
              await ProfileCubit().getProfile();
              context.push('/subscription-result?status=success');
            } else if (url.contains('cancel')) {
              Navigator.pop(context, false); // Payment cancelled
               context.push('/subscription-result?status=canceled');
            }
            else if (url.contains('error')) {
              Navigator.pop(context, false); // Payment cancelled
               context.push('/subscription-result?status=error');
            }
          },
          onPageFinished: (_) => setState(() => isLoading = false),
          onWebResourceError: (error) => debugPrint('Web error: ${error.description}'),
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with PayPal')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: Text(""),
            ),
        ],
      ),
    );
  }
}
