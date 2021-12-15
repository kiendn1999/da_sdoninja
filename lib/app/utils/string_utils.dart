class StringUtils {
  static String getPNGImageAssets(String image) => "assets/images/$image.png";
  static String getSVGImageAssets(String image) =>
      "assets/images/$image.svg";

  static String getImageGifUrlAssets(String image) =>
      "assets/images/$image.gif";

  static String formatMinute(int seconds) {
    return (seconds / 60).toStringAsFixed(0);
  }

  static String formatSeconds(int seconds) {
    return (seconds % 60).toStringAsFixed(0);
  }
}
