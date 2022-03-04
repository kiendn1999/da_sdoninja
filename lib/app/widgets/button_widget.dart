import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/constant/theme/app_shadows.dart';
import 'package:flutter/material.dart';

Widget buttonWithRadius10({
  required void Function() onPressed,
  required Widget child,
  EdgeInsetsGeometry? padding,
  Size? fixedSize,
  Color? color,
  EdgeInsetsGeometry? margin,
}) =>
    Container(
        margin: margin,
        child: AppShadow.lightShadow(
            child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: Size.zero,
            primary: color,
            fixedSize: fixedSize,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          ),
        )));

Widget buttonWithRadius90({
  required void Function() onPressed,
  required Widget child,
  Size? fixedSize,
  double horizontalPadding = 0,
  double verticalPadding = 0,
  Color? color,
  double marginTop = 0,
}) =>
    Container(
        margin: EdgeInsets.only(top: marginTop),
        child: AppShadow.lightShadow(
            child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            fixedSize: fixedSize,
            primary: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius90)),
          ),
        )));

Widget outLineButtonWithRadius90({
  required void Function() onPressed,
  required Widget child,
  Size? fixedSize,
  double horizontalPadding = 0,
  double verticalPadding = 0,
  Color? color,
  double marginTop = 0,
}) =>
    Container(
        margin: EdgeInsets.only(top: marginTop),
        child: AppShadow.lightShadow(
            child: OutlinedButton(
          onPressed: onPressed,
          child: child,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            fixedSize: fixedSize,
          ),
        )));
