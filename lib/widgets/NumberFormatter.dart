class NumberFormatter {
  // ignore: missing_return
  static String formatter(String currentBalance) {
    try {
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      double value = double.parse(currentBalance);

      if (value < 100000) {
        return value.toStringAsFixed(2);
      } else if (value >= 100000 && value < (100000 * 10 * 10)) {
        double result = value / 100000;
        return result.toStringAsFixed(2) + "Lac";
      } else if (value >= (100000 * 10 * 10) &&
          value < (100000 * 10 * 10 * 100)) {
        double result = value / (100000 * 10 * 10);
        return result.toStringAsFixed(2) + "Cr";
      } else {
        double result = value / (100000 * 10 * 10);
        return result.toStringAsFixed(2) + "Cr";
      }
    } catch (e) {
      print(e);
    }
  }
}
