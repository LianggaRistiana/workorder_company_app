class FcmDedupStore {
  static final Set<String> _handled = {};

  static bool isDuplicate(String? id) {
    if (id == null) return false;
    if (_handled.contains(id)) return true;

    _handled.add(id);
    return false;
  }
}
