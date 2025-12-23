import 'package:flutter/material.dart';
import '../../core/spec_constants.dart';

class JellyTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const JellyTap({super.key, required this.child, required this.onTap});

  @override
  State<JellyTap> createState() => _JellyTapState();
}

class _JellyTapState extends State<JellyTap> {
  double _scale = 1.0;

  Future<void> _run() async {
    if (widget.onTap == null) return;
    setState(() => _scale = 0.94);
    await Future.delayed(const Duration(milliseconds: 70));
    setState(() => _scale = 1.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: SpecConst.jellyDuration,
      curve: SpecConst.jellyCurve,
      scale: _scale,
      child: InkWell(
        borderRadius: BorderRadius.circular(SpecConst.radius),
        onTap: widget.onTap == null ? null : _run,
        child: widget.child,
      ),
    );
  }
}
