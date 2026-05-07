import 'dart:math';

class RandomString {
  static String generate() {
    final rand = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(99999)}';
  }
}
