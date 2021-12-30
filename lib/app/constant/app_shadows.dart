import 'package:flutter/cupertino.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AppShadow {
  static boldShadow({required Widget child}) {
    return SimpleShadow(
      child: Padding(
        padding: const EdgeInsets.all(0.65),
        child: child,
      ),
      offset: const Offset(10, 10),
      sigma: 2,
      opacity: 1,
    );
  }

  static lightShadow({required Widget child}) {
    return SimpleShadow(
      child: Padding(
        padding: const EdgeInsets.all(0.65),
        child: child,
      ),
      offset: const Offset(3, 3),
      sigma: 2.5,
      opacity: 1,
    );
  }
}
