// lib/core/services/camera_service.dart
import 'package:camera/camera.dart';
import 'dart:async';

class CameraService {
  CameraController? controller;
  List<CameraDescription>? _cameras;
  bool isInitialized = false;

  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Default to the first available camera, prefer back camera
      CameraDescription selectedCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );
      controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: true, // Assuming audio is needed
      );
      await controller!.initialize();
      isInitialized = true;
    } else {
      throw Exception("No cameras available");
    }
  }

  Future<XFile> recordVideo({required int seconds}) async {
    if (controller == null || !controller!.value.isInitialized || !isInitialized) {
      throw Exception("Camera not initialized or not ready.");
    }
    if (controller!.value.isRecordingVideo) {
      throw Exception("Already recording.");
    }
    await controller!.startVideoRecording();
    await Future.delayed(Duration(seconds: seconds));
    if (controller!.value.isRecordingVideo) {
      return await controller!.stopVideoRecording();
    } else {
      // This case might happen if recording was stopped by other means
      // or if the duration was very short and it stopped before this check.
      // You might need to handle this based on your app's logic.
      throw Exception("Recording was not active when stop was attempted.");
    }
  }

  void dispose() {
    controller?.dispose();
    isInitialized = false;
  }
}
