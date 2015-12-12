part of corsac_router;

/// Represents parametrized HTTP (REST) resource.
///
/// Resources are defined by parametrized [path] template and a list of
/// allowed [httpMethods].
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
  HttpResource(String path, List<String> httpMethods)
      : path = path,
        pathRegExp = _buildPathRegExp(path),
        httpMethods =
            new List.unmodifiable(httpMethods.map((i) => i.toUpperCase())),
        parameters = _extractPathParameters(path);

  /// Returns true if provided [uri] and [httpMethod] match this resource.
  bool matches(Uri uri, [String httpMethod]) {
    if (httpMethod != null) {
      return this.httpMethods.contains(httpMethod.toUpperCase()) &&
          this.pathRegExp.hasMatch(uri.path);
    } else {
      return pathRegExp.hasMatch(uri.path);
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
