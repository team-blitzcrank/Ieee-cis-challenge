import 'package:flutter/material.dart';
import '../utils.dart';
import '../profile.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// ProfileData class definition


// Function to retrieve user data from SharedPreferences
ProfileData? userFromPrefs(SharedPreferences prefs) {
  final Map<String, dynamic> json =
      jsonDecode(prefs.getString('avatar') ?? '{}');
  if (json.isNotEmpty) {
    final avatarUrl = json['data']['url'];
    final avatarId =
        avatarUrl?.split('/').last.toString().replaceAll('.glb', '').trim();
    return ProfileData(avatarId, avatarUrl: avatarUrl);
  }
  return null;
}
class AvatarScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final String? assetGlbUrl;

  const AvatarScreen({
    super.key,
    required this.prefs,
    this.assetGlbUrl,
  });

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  Future<void> _initWebViewController() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'AvatarCreated',
        onMessageReceived: (JavaScriptMessage message) async {
          final data = jsonDecode(message.message);
          await widget.prefs.setString('avatar', data['data']['url']);

          if (!mounted) return;

          final user = userFromPrefs(widget.prefs);
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(data: user),
              ),
            );
          }
        },
      )
      ..addJavaScriptChannel(
        'LoadingStatus',
        onMessageReceived: (JavaScriptMessage message) {
          setState(() {
            _isLoading = message.message == 'loading';
          });
        },
      );

    String fileContent = await rootBundle.loadString('assets/iframe.html');
    if (widget.assetGlbUrl != null) {
      final lastAvatar = widget.prefs.getString('avatar');
      if (lastAvatar != null) {
        fileContent =
            fileContent.replaceAll('const subdomain = \'zen-55evg5\';', '''
          const subdomain = 'zen-55evg5';
          const lastAvatar = '$lastAvatar';
          const assetGlbUrl = '${widget.assetGlbUrl}';
          ''');
      }
    }

    await _webViewController.loadHtmlString(fileContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Avatar'),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
        ],
      ),
    );
  }
}
