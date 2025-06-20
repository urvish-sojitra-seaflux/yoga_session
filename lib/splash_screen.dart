import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practice_app/yoga_session/yoga_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  void startTimer() {
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const YogaScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      animationBehavior: AnimationBehavior.normal,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
    ));
    _controller.forward();
    startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _timer = null;
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _animation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(colors: [
                            Colors.blue.shade400,
                            Colors.redAccent,
                            Colors.amberAccent,
                            Colors.blue.shade900,
                          ]).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'Welcome \nLets Start',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
