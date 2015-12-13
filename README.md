# Corsac Dart HTTP routing library

[![Build Status](https://img.shields.io/travis-ci/corsac-dart/router.svg?branch=master&style=flat-square)](https://travis-ci.org/corsac-dart/router)
[![Coverage Status](https://img.shields.io/coveralls/corsac-dart/router.svg?branch=master&style=flat-square)](https://coveralls.io/github/corsac-dart/router?branch=master)
[![License](https://img.shields.io/badge/license-BSD--2-blue.svg?style=flat-square)](https://raw.githubusercontent.com/corsac-dart/router/master/LICENSE)


Simple HTTP routing library for server-side applications.

## Installation

There is no Pub package yet so you have to use git dependency for now:

```yaml
dependencies:
  corsac_router:
    git: https://github.com/corsac-dart/router.git
```

## Usage

```dart
import 'package:corsac_router/corsac_router.dart';

// First define some `HttpResource`s and register with the `Router`.
var router = new Router();
router.resources[new HttpResource('/users', ['GET'])] = null;
router.resources[new HttpResource('/users/{userId}', ['GET'])] = null;

// Then in your HttpServer you can use it to match against incoming HTTP
// requests.

var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
await for (HttpRequest request in server) {
  MatchResult result = router.match(request.uri, request.method);
  if (result.hasMatch) {
    // access matched resource and other data via returned result
    // ...
  } else {
    request.response.statusCode = 404;
  }
  request.response.close();
}
```

## License

BSD-2
