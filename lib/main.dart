import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/screens/home_screen.dart';
import 'package:tiktok_mate/ui/screens/video_screen.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _listenStream();
  }

  void _handleInitialLink() async {
    final link = await getInitialLink();

    if (link != null) {
      _navigateToLink(link);
    }
  }

  void _listenStream() async {
    linkStream.listen((link) {
      if (link != null) {
        _navigateToLink(link);
      }
    });
  }

  void _navigateToLink(String link) {
    _navigatorKey.currentState!.pushReplacementNamed(VideoScreen.routeName, arguments: link);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'TikTok Mate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        VideoScreen.routeName: (context) => const VideoScreen(),
      },
    );
  }
}
