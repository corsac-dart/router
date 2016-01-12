part of corsac_router;

/// Represents a parametrized HTTP (REST) resource.
///
/// Resources are defined by a [path] template and a list of
/// allowed [httpMethods]. Optional [attributes] map can be provided as well.
class HttpResource {
  static final RegExp _paramMatcher = new RegExp(r"{[a-zA-Z0-9]+}");
  static final String _paramRegExp = "([^\/]+)";

  /// Parametrized path template for this resource.
  final String path;

  /// List of allowed HTTP methods (uppercase).
  final List<String> httpMethods;

  /// Regular expression used to check if actual Uri path matches this resource.
  final RegExp pathRegExp;

  /// List of parameter names for this resource.
  final List<String> parameters;

  final Map attributes;

  /// Creates new HttpResource.
  ///
  /// [path] is a parametrized template of [Uri] path. Parameters must be
  /// enclosed in curly braces. Examples:
  ///
  ///     /profile
  ///     /users/{userId}
  ///     /users/{userId}/status/{status}
  ///
  /// [httpMethods] must contain a list of allowed (supported) HTTP methods.
  ///
  /// The [attributes] parameter can contain arbitrary data. These attributes
  /// (if provided) will be included in matching process, a match will only
  /// occur if attributes associated with the resource are equal to the value
  /// passed to `matches` method.
  ///
  /// Typical example of an attribute is a version of an HTTP API.
  HttpResource(String path, Iterable<String> httpMethods, {Map attributes})
      : path = path,
        pathRegExp = _buildPathRegExp(path),
        httpMethods = new List.unmodifiable(
            httpMethods.map((i) => i.toUpperCase()).toSet()),
        parameters = _extractPathParameters(path),
        attributes = attributes ?? new Map();

  /// Returns true if provided [uri], [httpMethod] and [attributes] match
  /// this resource.
  bool matches(Uri uri, {String httpMethod, Map attributes}) {
    var result = false;
    if (httpMethod != null) {
      result = this.httpMethods.contains(httpMethod.toUpperCase()) &&
          this.pathRegExp.hasMatch(uri.path);
    } else {
      result = pathRegExp.hasMatch(uri.path);
    }

    if (this.attributes.isNotEmpty) {
      var eq = const MapEquality();
      return result ? eq.equals(this.attributes, attributes) : false;
    } else {
      return result;
    }
  }

  /// Matches provided [uri] and [httpMethod] and returns list of extracted
  /// parameter values.
  Map<String, String> resolveParameters(Uri uri) {
    Map<String, String> resolvedParams = new Map();

    Match m = pathRegExp.firstMatch(uri.path);
    if (this.parameters.length != m.groupCount) {
      return null;
    }

    int i = 1;
    for (var key in this.parameters) {
      resolvedParams[key] = m.group(i);
      i++;
    }

    return resolvedParams;
  }

  bool operator ==(HttpResource o) {
    final listEq = const ListEquality();
    final mapEq = const MapEquality();
    return o is HttpResource &&
        (o.path == this.path) &&
        listEq.equals(o.httpMethods, this.httpMethods) &&
        mapEq.equals(o.attributes, this.attributes);
  }

  int get hashCode {
    return hash4(path, hashObjects(httpMethods), hashObjects(attributes.keys),
        hashObjects(attributes.values));
  }

  static RegExp _buildPathRegExp(String parametrizedPath) {
    var param = _paramMatcher.stringMatch(parametrizedPath);
    while (param != null) {
      parametrizedPath = parametrizedPath.replaceFirst(param, _paramRegExp);
      param = _paramMatcher.stringMatch(parametrizedPath);
    }

    return new RegExp("^" + parametrizedPath + r"$");
  }

  /// Extracts parameters from the path template.
  static List<String> _extractPathParameters(String parametrizedPath) {
    var params = [];
    var param = _paramMatcher.stringMatch(parametrizedPath);
    while (param != null) {
      parametrizedPath = parametrizedPath.replaceFirst(param, _paramRegExp);
      param = param.substring(1, param.length - 1);
      params.add(param);
      param = _paramMatcher.stringMatch(parametrizedPath); // get next
    }
    return new List.unmodifiable(params);
  }
}
