import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/screens/video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TikTok Mate")),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Insira aqui o link do vídeo'
              ),
              controller: _controller,
              minLines: 1,
              maxLines: 6,
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.go,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(onPressed: _submit, child: const Text('CONFIRMAR')),
          ),
        ],
      ),
    );
  }

  void _submit() {
    Navigator.pushNamed(context, VideoScreen.routeName, arguments: _controller.text);
  }
}
