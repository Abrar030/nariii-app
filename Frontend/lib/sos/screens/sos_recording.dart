import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // For platform-specific logic

// Assuming CameraService is in the core/services directory like LocationService
import 'camera_service.dart';
import 'location_service.dart'; // You'll need to create/adjust this path

const Color kAppPrimaryRed = Color(0xFFF40000);

class SOSRecordingScreen extends StatefulWidget {
  const SOSRecordingScreen({super.key});
  static const String routeName = '/sos-recording';

  @override
  State<SOSRecordingScreen> createState() => _SOSRecordingScreenState();
}

class _SOSRecordingScreenState extends State<SOSRecordingScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin { // Added SingleTickerProviderStateMixin
  // Old camera controller, will be managed by CameraService
  // CameraController? _cameraController;
  // List<CameraDescription>? _cameras;
  // bool _isCameraInitialized = false;

  // New service instances
  final CameraService _cameraService = CameraService();
  final LocationService _locationService = LocationService();

  // State variables from your provided code
  bool _permissionsGranted = false;
  String _location = "Detecting location..."; // Initial message

  // Animation controllers from your provided code
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isRecording = false;
  final int _recordingDurationSeconds = 5;
  int _currentCountdown = 5;
  Timer? _recordingTimer;
  Timer? _countdownTimer;
  XFile? _videoFile;

  // Location permission state for the recording screen itself
  bool _hasLocationPermissionForScreen = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingTimer?.cancel();
    _countdownTimer?.cancel();
    _cameraService.dispose(); // Use the service to dispose the camera controller
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize(); // Call your new initialize function

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack),
    );
  }

  Future<void> _initialize() async {
    // Permissions for camera and microphone are now expected to be granted
    // by the SOSButton before navigating to this screen.
    // This screen will primarily request location when recording starts.

    // Initialize camera service
    try {
      await _cameraService.initialize();
      if (mounted) {
        setState(() {
          // _isCameraInitialized is now implicitly handled by _cameraService.isInitialized
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Failed to initialize camera: $e");
      }
      return;
    }

    // Check initial location permission status (optional, as it's requested on record)
    if (!kIsWeb) {
      final status = await Permission.locationWhenInUse.status;
      if (mounted) {
        setState(() {
          _hasLocationPermissionForScreen = status.isGranted;
        });
      }
    } else {
       // On web, location is handled by browser, assume not explicitly granted via permission_handler here
       if (mounted) setState(() => _hasLocationPermissionForScreen = false);
    }

    // The original _initialize from your snippet also set _permissionsGranted.
    // We can set it based on camera service initialization.
    if (mounted) {
      setState(() {
        _permissionsGranted = _cameraService.isInitialized;
      });
    }

    // The location fetching part from your snippet can be moved to _startRecording
    // or kept here if you want to display initial location.
    // For now, let's keep it simple and focus on camera.
    // final position = await _locationService.getCurrentPosition();
    // if (position != null && mounted) {
    //   setState(() {
    //     _location = "Lat: ${position.latitude}, Long: ${position.longitude}";
    //   });
    // }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final CameraController? cameraController = _cameraController; // Old
    final CameraController? cameraController = _cameraService.controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // cameraController.dispose(); // Should be handled by CameraService if it manages its own lifecycle
      _cameraService.dispose(); // Or a specific pause method if available
    } else if (state == AppLifecycleState.resumed) {
      // _initializeCamera(_cameraController!.description); // Old
      _cameraService.initialize(); // Re-initialize service if needed
    }
  }

  Future<void> _startRecording() async {
    if (_cameraService.controller == null || !_cameraService.controller!.value.isInitialized || !_cameraService.isInitialized) {
      _showErrorDialog("Camera not initialized.");
      return;
    }

    try {
      // Ensure the service's controller is used
      if (_cameraService.controller == null || !_cameraService.controller!.value.isInitialized) {
        _showErrorDialog("Camera controller not ready for recording.");
        return;
      }
      await _cameraService.controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _currentCountdown = _recordingDurationSeconds;
        _animationController.stop();
        // Reset animation to base scale (1.0) for a non-pulsing recording button
        _animationController.value = 0; 
      }); // Correctly closing setState here
      // Request location permission just before starting recording
      if (!kIsWeb) {
        PermissionStatus locationStatus = await Permission.locationWhenInUse.request();
        if (mounted) {
          setState(() {
            _hasLocationPermissionForScreen = locationStatus.isGranted;
          });
          if (locationStatus.isGranted) {
            // Fetch location if permission granted
            final position = await _locationService.getCurrentPosition();
            if (position != null && mounted) {
              setState(() {
                _location = "Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}";
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Location acquired: $_location")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location permission denied. Recording without location.")),
            );
          }
        }
      } else {
        // Handle web location separately if needed, e.g., using geolocator directly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location on web is handled by the browser.")),
        );
      }

      // Start actual video recording using the service
      // The service itself might handle the timer, or you keep it here.
      // For simplicity, let's assume the service's recordVideo handles the duration.
      // await _cameraService.controller!.startVideoRecording(); // If service doesn't auto-start

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentCountdown > 0) {
          setState(() {
            _currentCountdown--;
          });
        }
      });

      _recordingTimer = Timer(Duration(seconds: _recordingDurationSeconds),
        () async {
        // if (_cameraController!.value.isRecordingVideo) { // Old
        if (_cameraService.controller?.value.isRecordingVideo ?? false) {
          await _stopRecording();
        }
      });
    } catch (e) {
      String errorMessage = "Recording failed: $e";
      if (e is CameraException) {
        errorMessage = "Recording failed: ${e.description}";
      }
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      _countdownTimer?.cancel();

      // final videoFile = await _cameraController!.stopVideoRecording(); // Old
      final videoFile = await _cameraService.controller!.stopVideoRecording(); // Use service's controller
      setState(() {
        _videoFile = videoFile;
        _isRecording = false;
      });
      _animationController.repeat(reverse: true); // Resume pulsing animation

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Video saved to: ${videoFile.path}"),
        backgroundColor: Colors.green,
      ));
      // TODO: Here you would use _location if it was captured successfully
      print("Video recorded. Location at time of recording: $_location");
    } catch (e) {
      String errorMessage = "Failed to stop recording: $e";
      if (e is CameraException) {
        errorMessage = "Failed to stop recording: ${e.description}";
      }
      _showErrorDialog(errorMessage);
    }
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use _permissionsGranted or _cameraService.isInitialized
    if (!_permissionsGranted || !_cameraService.isInitialized || _cameraService.controller == null) {
      // Show a more informative UI if permissions were denied by SOSButton
      // This screen assumes camera/mic permissions are granted before reaching it.
      // If not, it means something went wrong or user revoked them.
      // bool cameraPermission = false; // These were unused
      // bool micPermission = false;    // These were unused

      // This is a bit redundant if SOSButton handles it, but good for robustness
      // In a real app, you might not need to re-check here if SOSButton is strict.
      // For now, let's assume we show loading or an error if camera service isn't ready.
      return Scaffold(
        appBar: AppBar(title: Text("SOS Recorder")),
        body: Center(child: CircularProgressIndicator(color: kAppPrimaryRed)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("SOS Recorder"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white), // For back button
      ),
      extendBodyBehindAppBar: true, // Allows camera preview to go behind appbar
      backgroundColor: Colors.black, // Sleek dark background
      body: Stack(
        alignment: Alignment.center, // Center alignment for children like countdown
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _cameraService.controller!.value.aspectRatio,
              child: CameraPreview(_cameraService.controller!),
            ),
          ),          
          if (_isRecording)
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 20, // Below AppBar
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: kAppPrimaryRed, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "REC ${_currentCountdown.toString().padLeft(1, '0')}s", // Simpler padding
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          if (_hasLocationPermissionForScreen && _location.isNotEmpty && _location != "Detecting location...")
            Positioned(
              bottom: 140, // Adjust to be above the record button + padding
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _location,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            child: InkWell(
              onTap: _toggleRecording,
              customBorder: const CircleBorder(),
              child: ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.white : kAppPrimaryRed,
                    boxShadow: [
                      BoxShadow(
                        color: _isRecording ? kAppPrimaryRed.withOpacity(0.6) : Colors.black.withOpacity(0.4),
                        blurRadius: _isRecording ? 12 : 8,
                        spreadRadius: _isRecording ? 4 : 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.videocam_rounded,
                    color: _isRecording ? kAppPrimaryRed : Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),),
        ],
      ),
    );
  }
}
