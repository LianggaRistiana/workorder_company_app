extension QueryMapExtension on Map<String, String> {
  Map<String, String> addQuery(
    String key,
    Object? value,
  ) {
    if (value == null) return this;

    return {
      ...this,
      key: value.toString(),
    };
  }

  Map<String, String> addQueries(
    Map<String, Object?> queries,
  ) {
    return {
      ...this,
      ...queries.map(
        (key, value) => MapEntry(
          key,
          value?.toString() ?? '',
        ),
      )..removeWhere((key, value) => value.isEmpty),
    };
  }
}

extension EndpointIdExtension on String {
  String byId(String id) => "$this/$id";

  String withQuery(Map<String, Object?> query) {
    final uri = Uri.parse(this);

    return uri
        .replace(
          queryParameters: query.map(
            (key, value) => MapEntry(
              key,
              value?.toString(),
            ),
          )..removeWhere((key, value) => value == null),
        )
        .toString();
  }
}
