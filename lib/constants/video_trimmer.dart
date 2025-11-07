// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// // import 'package:video_trimmer/widgets/video_viewer.dart';
// // import 'package:video_trimmer/widgets/trim_viewer.dart';
//
// class VideoTrimmerPage extends StatefulWidget {
//   final Trimmer trimmer;
//   final File videoFile;
//
//   const VideoTrimmerPage({
//     super.key,
//     required this.trimmer,
//     required this.videoFile,
//   });
//
//   @override
//   State<VideoTrimmerPage> createState() => _VideoTrimmerPageState();
// }
//
// class _VideoTrimmerPageState extends State<VideoTrimmerPage> {
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//   bool _isTrimming = false;
//   bool _isLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVideo();
//   }
//
//   Future<void> _loadVideo() async {
//     await widget.trimmer.loadVideo(videoFile: widget.videoFile);
//     setState(() => _isLoaded = true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff1E1E1E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff6a7691),
//         title: const Text("Trim Video"),
//         actions: [
//           TextButton(
//             onPressed: _isTrimming
//                 ? null
//                 : () async {
//               setState(() => _isTrimming = true);
//
//               await widget.trimmer.saveTrimmedVideo(
//                 startValue: _startValue,
//                 endValue: _endValue,
//                 onSave: (String? outputPath) {
//                   setState(() => _isTrimming = false);
//                   if (outputPath != null && mounted) {
//                     Navigator.pop(context, outputPath);
//                   }
//                 },
//               );
//             },
//             child: const Text(
//               "SAVE",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: !_isLoaded
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           SizedBox(
//             height: 200,
//             child: VideoViewer(trimmer: widget.trimmer),
//           ),
//           TrimViewer(
//             showDuration: true,
//             trimmer: widget.trimmer,
//             viewerHeight: 80.0,
//             viewerWidth: MediaQuery.of(context).size.width,
//             maxVideoLength: const Duration(seconds: 60),
//             onChangeStart: (value) => _startValue = value,
//             onChangeEnd: (value) => _endValue = value,
//             onChangePlaybackState: (value) {},
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
