/// Simple HTTP routing library for server-side applications.
///
/// The Router library as a standalone component which can be used on it's own.
/// It's main purpose is to provide easy yet flexible way to define HTTP routes
/// for your server-side applications.
///
/// It has zero dependencies on it's own.
///
/// To use this library in your code:
///
///    import 'package:corsac_router/corsac_router.dart';
///
/// Implementation of routes is loosely based on the idea of
/// Web (HTTP) resources which can also be referred to as REST resources.
library corsac_router;

import 'package:collection/equality.dart';

part 'src/resource.dart';
part 'src/router.dart';
