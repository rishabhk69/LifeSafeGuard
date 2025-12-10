import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/localization/fitness_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class ModernTrimDialog extends StatefulWidget {
  final File file;

  const ModernTrimDialog({super.key, required this.file});

  @override
  State<ModernTrimDialog> createState() => _ModernTrimDialogState();
}

class _ModernTrimDialogState extends State<ModernTrimDialog> {
  late VideoPlayerController _controller;
  double start = 0.0, end = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          end = _controller.value.duration.inMilliseconds.toDouble();
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  Future<void> trimVideo() async {
    final selectedDurationSeconds = (end - start) / 1000;

    if (selectedDurationSeconds > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Maximum allowed trimmed duration is 20 seconds.\n"
                "Selected: ${selectedDurationSeconds.toStringAsFixed(1)} sec",
          ),
        ),
      );
      return;
    }

    final output = "${widget.file.path}_trimmed.mp4";

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final cmd =
        "-i ${widget.file.path} -ss ${start / 1000} -to ${end / 1000} -c copy $output";

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();

    Navigator.pop(context); // close loader

    if (ReturnCode.isSuccess(rc)) {
      Navigator.pop(context, File(output)); // return trimmed file
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error trimming video")),
      );
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.isInitialized
                  ? _controller.value.aspectRatio
                  : 16 / 9,
              child: VideoPlayer(_controller),
            ),

            const SizedBox(height: 10),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                thumbColor: Colors.white,
              ),
              child: RangeSlider(
                values: RangeValues(start, end),
                min: 0,
                max: _controller.value.isInitialized
                    ? _controller.value.duration.inMilliseconds.toDouble()
                    : 1,
                onChanged: (values) {
                  final diff = values.end - values.start;

                  // block if > 20 sec
                  if (diff > 20000) return;

                  setState(() {
                    start = values.start;
                    end = values.end;
                  });

                  _controller.seekTo(Duration(milliseconds: start.toInt()));
                },

              ),
            ),

            Text(
              "Start: ${(start / 1000).toStringAsFixed(2)}s   "
                  "End: ${(end / 1000).toStringAsFixed(2)}s",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: trimVideo,
                  child: const Text("SAVE", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FittedBox(child: Text(GuardLocalizations.of(context)!.translate("videoUploadLimitText") ?? "",
            style: TextStyle(
              color: Colors.white
            ),))
          ],
        ),
      ),
    );
  }
}
