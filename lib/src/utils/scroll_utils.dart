class ScrollUtils {
  static double calcThumbSize({required double contentSize, required double viewportSize}) {
    double viewableRatio = viewportSize / contentSize;
    double scrollBarArea = viewportSize;
    double thumbHeight =  scrollBarArea * viewableRatio;
    return thumbHeight;
  }
}