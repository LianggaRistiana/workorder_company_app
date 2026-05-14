String formatValue(num value) {
  if (value is int) return value.toString();

  return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
}
