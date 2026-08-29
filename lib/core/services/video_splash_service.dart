import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSplashService {
  static VideoPlayerController? controller;
  static bool isReady = false;

  static Future<void> preload() async {
    try {
      controller = VideoPlayerController.asset('assets/video/screen.mp4');
      await controller!.initialize();
      await controller!.setVolume(0.0);
      controller!.setLooping(false);
      isReady = true;
    } catch (e) {
      debugPrint('VideoSplashService preload error: $e');
      isReady = false;
    }
  }
}
