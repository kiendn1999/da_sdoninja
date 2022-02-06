import 'dart:math' as math;
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CircularProgessApp extends StatefulWidget {
  final double? width;
  final double? height;
  final Duration duration;
  final Color? color;

  const CircularProgessApp({Key? key, this.width, this.height, this.duration = const Duration(seconds: 1, milliseconds: 300), this.color}) : super(key: key);

  @override
  _CircularProgessAppState createState() => _CircularProgessAppState();
}

class _CircularProgessAppState extends State<CircularProgessApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Image.asset(
        AppImages.icLogoLogin.getPNGImageAssets,
        width: widget.width ?? 30.h,
        height: widget.height ?? 30.h,
        color: widget.color ?? AppColors.primaryDarkModeColor,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
