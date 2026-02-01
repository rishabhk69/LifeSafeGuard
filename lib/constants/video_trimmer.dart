import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:untitled/localization/fitness_localization.dart';

class ModernTrimDialog extends StatefulWidget {
  final File file;

  const ModernTrimDialog({super.key, required this.file});

  @override
  State<ModernTrimDialog> createState() => _ModernTrimDialogState();
}

class _ModernTrimDialogState extends State<ModernTrimDialog> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }
  Future<void> _loadVideo() async {
    await _trimmer.loadVideo(videoFile: widget.file);

    final duration = _trimmer.videoPlayerController!.value.duration;

    setState(() {
      _startValue = 0.0;
      _endValue = duration.inSeconds.toDouble();
    });
  }


  Future<void> _saveTrimmedVideo() async {
    if (_endValue <= _startValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid trim range")),
      );
      return;
    }

    final selectedDuration = _endValue - _startValue;

    // if (selectedDuration > 20) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         "Maximum allowed trimmed duration is 20 seconds.\n"
    //             "Selected: ${selectedDuration.toStringAsFixed(1)} sec",
    //       ),
    //     ),
    //   );
    //   return;
    // }

    setState(() => _isSaving = true);

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        setState(() => _isSaving = false);

        if (outputPath != null) {
          Navigator.pop(context, File(outputPath));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error trimming video")),
          );
        }
      },
    );
  }


  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              GuardLocalizations.of(context)!
                  .translate("videoUploadLimitText") ??
                  "",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 12),

            /// VIDEO PREVIEW
            AspectRatio(
              aspectRatio: _trimmer.videoPlayerController!.value.aspectRatio,
              child: VideoViewer(trimmer: _trimmer),
            ),


            const SizedBox(height: 12),

            /// TRIM SLIDER
            TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 60,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 20),
              onChangeStart: (value) {
                setState(() {
                  _startValue = value;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _endValue = value;
                });
              },
              onChangePlaybackState: (isPlaying) {},
            ),


            const SizedBox(height: 8),

            Text(
              "Start: ${_startValue.toStringAsFixed(2)}s   "
                  "End: ${_endValue.toStringAsFixed(2)}s",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 12),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed:
                  _isSaving ? null : () => Navigator.pop(context),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: _isSaving ? null : _saveTrimmedVideo,
                  child: _isSaving
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    "SAVE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
