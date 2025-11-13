import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:image_picker/image_picker.dart';

class VideoTrimmerPage extends StatefulWidget {
  final File videoFile;

  const VideoTrimmerPage({
    super.key,
    required this.videoFile,
  });

  @override
  State<VideoTrimmerPage> createState() => _VideoTrimmerPageState();
}

class _VideoTrimmerPageState extends State<VideoTrimmerPage> {
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isTrimming = false;
  bool _isLoaded = false;
  final Trimmer trimmer = Trimmer();

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    await trimmer.loadVideo(videoFile: widget.videoFile);
    setState(() => _isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xff6a7691),
        title: const Text("Trim Video"),
        actions: [
          TextButton(
            onPressed: _isTrimming
                ? null
                : () async {
              setState(() => _isTrimming = true);

              await trimmer.saveTrimmedVideo(
                startValue: _startValue,
                endValue: _endValue,
                onSave: (String? outputPath) {
                  setState(() => _isTrimming = false);
                  if (outputPath != null && mounted) {
                    Navigator.pop(context, outputPath);
                  }
                },
              );
            },
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(
            height: 200,
            child: VideoViewer(trimmer: trimmer),
          ),
          Container(
            color: Colors.blue.withOpacity(0.2),
            child: TrimViewer(
              showDuration: true,
              trimmer: trimmer,
              viewerHeight: 80.0,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 20),
              onChangeStart: (value) => _startValue = value,
              onChangeEnd: (value) => _endValue = value,
              onChangePlaybackState: (value) {},
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TrimTestScreen extends StatefulWidget {
  const TrimTestScreen({super.key});

  @override
  State<TrimTestScreen> createState() => _TrimTestScreenState();
}

class _TrimTestScreenState extends State<TrimTestScreen> {
  String? trimmedVideoPath;

  Future<void> pickAndTrimVideo() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked == null) return;

    // Navigate to the trimming screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoTrimmerPage(
          videoFile: File(picked.path),
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() => trimmedVideoPath = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Trimmed video saved at: $trimmedVideoPath")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Trimmer Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickAndTrimVideo,
              child: const Text("Pick & Trim Video"),
            ),
            const SizedBox(height: 20),
            if (trimmedVideoPath != null)
              Text(
                "Trimmed video:\n$trimmedVideoPath",
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

