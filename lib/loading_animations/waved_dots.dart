import 'package:flutter/material.dart';
import 'package:practice_app/loading_animations/animations_controller_utils.dart';

class WaveDots extends StatefulWidget {
  final double size;
  final Color color;

  const WaveDots({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  State<WaveDots> createState() => _WaveDotsState();
}

class _WaveDotsState extends State<WaveDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  Widget _buildDot(
          {required Offset begin,
          required Offset end,
          required Interval interval}) =>
      Transform.translate(
        offset: _controller.eval(
          Tween<Offset>(begin: begin, end: end),
          curve: interval,
        ),
        child: Container(
          width: widget.size / 4,
          height: widget.size / 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      );

  Widget _buildBottomDot({required double begin, required double end}) {
    final double offset = -widget.size / 8;
    return _buildDot(
      begin: Offset.zero,
      end: Offset(0.0, offset),
      interval: Interval(begin, end),
    );
  }

  Widget _buildTopDot({required double begin, required double end}) {
    final double offset = -widget.size / 8;
    return _buildDot(
      begin: Offset(0.0, offset),
      end: Offset.zero,
      interval: Interval(begin, end),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => SizedBox(
        width: size * 2,
        height: size * 2,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _controller.value <= 0.50
                    ? _buildBottomDot(begin: 0.12, end: 0.50)
                    : _buildTopDot(begin: 0.62, end: 1.0),
                _controller.value <= 0.44
                    ? _buildBottomDot(begin: 0.06, end: 0.44)
                    : _buildTopDot(begin: 0.56, end: 0.94),
                _controller.value <= 0.38
                    ? _buildBottomDot(begin: 0.0, end: 0.38)
                    : _buildTopDot(begin: 0.50, end: 0.88),
                _controller.value <= 0.32
                    ? _buildBottomDot(begin: 0.0, end: 0.32)
                    : _buildTopDot(begin: 0.44, end: 0.82),
                _controller.value <= 0.26
                    ? _buildBottomDot(begin: 0.0, end: 0.26)
                    : _buildTopDot(begin: 0.38, end: 0.76),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
