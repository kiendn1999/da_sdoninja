extension LocalImagePathAssets on String {
  String get getPNGImageAssets => "assets/images/$this.png";
  String get getSVGImageAssets => "assets/images/$this.svg";

  // static String formatMinute(int seconds) {
  //   return (seconds / 60).toStringAsFixed(0);
  // }

  // static String formatSeconds(int seconds) {
  //   return (seconds % 60).toStringAsFixed(0);
  // }
}
