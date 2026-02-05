extension SafeNumberParsing on dynamic {
  num? toNumSafe() {
    if (this == null) return null;

    if (this is num) return this;
    if (this is String) return num.tryParse(this);

    return null;
  }
}

extension StringToNum on String {
  num? toNum() => num.tryParse(this);
}
