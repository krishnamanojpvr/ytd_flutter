import 'package:flutter/material.dart';
import './downloader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _textController;
  bool _downloading = false;

  @override
  void initState() {
    _textController = TextEditingController(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(labelText: "Paste Youtube Video Link..."),
            ),
            ElevatedButton(
              onPressed: _downloading ? null : _startDownload,
              child: _downloading
                  ? const CircularProgressIndicator() // Show progress indicator when downloading
                  : const Text("Download Video"),
            ),
          ],
        ),
      ),
    );
  }

  void _startDownload() {
    String videoLink = _textController.text.trim();
    if (videoLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No link pasted")));
    } else {
      setState(() {
        _downloading = true; // Set downloading to true
      });
      Download().downloadVideo(videoLink, "video").then((_) {
        // Download completed successfully
        setState(() {
          _downloading = false; // Reset downloading to false
        });
      }).catchError((error) {
        // Download failed, show error message
        setState(() {
          _downloading = false; // Reset downloading to false
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose(); 
    super.dispose();
  }
}
