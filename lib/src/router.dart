part of corsac_router;

/// Basic implementation of a router.
class Router {
  /// Map of registered [HttpResource]s to user-defined data user wants to
  /// associate with particular resource. The data can be pretty much anything.
  /// Some examples include:
  ///
  /// * [Type] of a controller (for MVC implementations)
  /// * [Function] handler (for simple solutions)
  ///
  /// You can always leave it as `null` if you don't need to associate any
  /// information with your resources.
  final Map<HttpResource, dynamic> resources = {};

  /// Matches [uri] and [httpMethod] to a resource.
  MatchResult match(Uri uri, String httpMethod, {Map attributes}) {
    var resource = resources.keys.firstWhere(
        (r) => r.matches(uri, httpMethod: httpMethod, attributes: attributes),
        orElse: () => null);
    if (resource is HttpResource) {
      return new MatchResult(resource, resources[resource],
          resource.resolveParameters(uri), resource.attributes);
    } else {
      return new MatchResult(null, null, null, null);
    }
  }
}

/// Result of matching an [Uri] with [Router].
class MatchResult {
  /// Matching HTTP resource.
  final HttpResource resource;

  /// Data associated with the resource.
  final dynamic data;

  /// Resource parameters extracted from the `Uri`.
  final Map<String, String> parameters;

  /// User-defined custom attributes associated with the resource.
  final Map attributes;

  MatchResult(this.resource, this.data, this.parameters, this.attributes);

  bool get hasMatch => this.resource is HttpResource;
}
