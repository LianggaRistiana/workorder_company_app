abstract class PropertyKey {
  String get key;
}

class IndexedPropertyKey implements PropertyKey {
  @override
  final String key;
  const IndexedPropertyKey(this.key);
}
