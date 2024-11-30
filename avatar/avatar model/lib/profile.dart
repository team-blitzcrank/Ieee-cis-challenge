import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ieee_zen/utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.data});

  final ProfileData data;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final WebViewController _controller;
  final api = 'https://api.readyplayer.me/v1/avatar/';
  bool isThreeD = false;
  late String twoDUrl;
  int idx = 0;

  @override
  void initState() {
    super.initState();
    twoDUrl = '$api${widget.data.avatarId}.png';
    _initWebViewController();
  }

  Future<void> _initWebViewController() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            debugPrint(widget.data.avatarUrl);
            _controller.runJavaScript(
                'window.loadViewer("${widget.data.avatarUrl}");');
          },
        ),
      );
    await loadHtmlFromAssets(_controller, 'assets/viewer.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 20,
              child: ToggleSwitch(
                initialLabelIndex: idx,
                labels: const ['2D', '3D'],
                cornerRadius: 20.0,
                totalSwitches: 2,
                customWidths: const [40, 40],
                onToggle: (index) => {
                  setState(() {
                    idx = index ?? 0;
                    isThreeD = index == 1;
                  })
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isThreeD)
            WebViewWidget(
              controller: _controller,
            )
          else
            Image.network(twoDUrl, fit: BoxFit.cover),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Roberty Joe ',
                style: GoogleFonts.bungeeInline(fontSize: 26),
                children: [
                  TextSpan(
                    text: '@robertyjoe',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'robertyjoe@artist.com',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Robery Joe is a 3D artist and '
              'designer based in New York City. '
              'He is a graduate of the Art Institute '
              'of New York City and has been working '
              'in the industry for 5 years.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to load HTML from assets into WebView
Future<void> loadHtmlFromAssets(
    WebViewController controller, String asset) async {
  String fileText = await rootBundle.loadString(asset);
  await controller.loadRequest(Uri.dataFromString(fileText,
      mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
}
