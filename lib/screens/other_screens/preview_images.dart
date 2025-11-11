import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class ImagePreviewGallery extends StatefulWidget {
  final List<File> mediaFiles; // can include images and videos
  final int initialIndex;

  const ImagePreviewGallery({
    super.key,
    required this.mediaFiles,
    this.initialIndex = 0,
  });

  @override
  State<ImagePreviewGallery> createState() => _ImagePreviewGalleryState();
}

class _ImagePreviewGalleryState extends State<ImagePreviewGallery> {
  late PageController _pageController;
  late List<File> _files;
  late int _currentIndex;

  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _files = widget.mediaFiles;
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _initializeVideoIfNeeded(_files[_currentIndex]);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideo(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi') ||
        path.endsWith('.mkv');
  }

  Future<void> _initializeVideoIfNeeded(File file) async {
    if (_isVideo(file)) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();
      _videoController!.play();
      _videoController!.setLooping(true);
      setState(() {});
    } else {
      _videoController?.dispose();
      _videoController = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _files.length,
            onPageChanged: (index) async {
              _currentIndex = index;
              await _initializeVideoIfNeeded(_files[index]);
            },
            itemBuilder: (context, index) {
              final file = _files[index];
              if (_isVideo(file)) {
                return Center(
                  child: _videoController != null &&
                      _videoController!.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                      : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return PhotoView(
                  imageProvider: FileImage(file),
                  backgroundDecoration:
                  const BoxDecoration(color: Colors.black),
                  heroAttributes: PhotoViewHeroAttributes(tag: file.path),
                );
              }
            },
          ),
          // Simple indicator (optional)
          Positioned(
            bottom: 20,
            child: Text(
              '${_currentIndex + 1}/${_files.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // Play/Pause toggle button for videos
          if (_isVideo(_files[_currentIndex]) &&
              _videoController != null &&
              _videoController!.value.isInitialized)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              },
              child: Center(
                child: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 70,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
