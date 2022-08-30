import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/screens/home_screen.dart';
import 'package:tiktok_mate/ui/screens/video_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
