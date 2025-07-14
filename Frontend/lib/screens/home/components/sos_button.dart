import 'package:flutter/material.dart';
import 'package:nariii_new/sos/screens/sos_recording.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:permission_handler/permission_handler.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSOSPress(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!mounted) return;

    if (cameraGranted && micGranted) {
      await Future.delayed(const Duration(milliseconds: 300));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SOSRecordingScreen()),
          );
        }
      });
    } else {
      String denied = "";
      if (!cameraGranted) denied += "Camera";
      if (!micGranted)
        denied += denied.isEmpty ? "Microphone" : " and Microphone";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "This feature requires $denied permission(s). Please enable them in app settings.",
          ),
          action: SnackBarAction(label: "Settings", onPressed: openAppSettings),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 200.0;
    const double borderWidth = 4.0;
    const double innerButtonSize = buttonSize - (borderWidth * 2);

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: SOSBorderPainter(
              animation: _controller,
              borderColor: const Color(0xFFF40000),
              borderWidth: borderWidth,
            ),
            size: const Size(buttonSize, buttonSize),
          ),
          Material(
            shape: const CircleBorder(),
            color: Colors.white,
            elevation: 35,
            child: InkWell(
              onTap: () => _handleSOSPress(context),
              customBorder: const CircleBorder(),
              splashColor: const Color.fromARGB(
                255,
                251,
                64,
                70,
              ).withOpacity(0.5),
              child: Container(
                width: innerButtonSize,
                height: innerButtonSize,
                alignment: Alignment.center,
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'sans-serif',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SOSBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color borderColor;
  final double borderWidth;

  SOSBorderPainter({
    required this.animation,
    this.borderColor = Colors.red,
    this.borderWidth = 4.0,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          borderColor,
          borderColor.withOpacity(0.7),
          borderColor.withOpacity(0.1),
        ],
        startAngle: 0.0,
        endAngle: vector.radians(90),
        stops: const [0.0, 0.4, 1.0],
        transform: GradientRotation(vector.radians(360.0 * animation.value)),
      ).createShader(rect);

    final outerPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final innerPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius - borderWidth));
    final borderPath = Path.combine(PathOperation.xor, outerPath, innerPath);

    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(covariant SOSBorderPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
