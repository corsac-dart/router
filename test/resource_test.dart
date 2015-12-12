library corsac_router.test;

import 'package:test/test.dart';
import 'package:corsac_router/corsac_router.dart';

void main() {
  group("Resource", () {
    test("it matches static route", () {
      HttpResource r = new HttpResource('/users', ['GET']);
      expect(r.matches(Uri.parse('/users'), 'GET'), isTrue);
      expect(r.matches(Uri.parse('/users'), 'get'), isTrue);
      expect(r.matches(Uri.parse('/users'), 'POST'), isFalse);
      expect(r.matches(Uri.parse('/users?status=active'), 'GET'), isTrue);
      expect(r.matches(Uri.parse('/users/'), 'GET'), isFalse);
      expect(r.matches(Uri.parse('/users/1'), 'GET'), isFalse);
    });

    test("it matches route with parameter", () {
      HttpResource r = new HttpResource('/users/{userId}', ['GET']);
      expect(r.matches(Uri.parse('/users/234'), 'GET'), isTrue);
      expect(r.matches(Uri.parse('/users/324?status=active'), 'GET'), isTrue);
      expect(r.matches(Uri.parse('/users/'), 'GET'), isFalse);
      expect(r.matches(Uri.parse('/users/123/'), 'GET'), isFalse);
      expect(r.matches(Uri.parse('/users/123/baz'), 'GET'), isFalse);
    });

    test("it extracts route parameters", () {
      HttpResource r = new HttpResource('/users/{userId}', ['GET']);
      var params = r.resolveParameters(Uri.parse('/users/234'));
      expect(params, isMap);
      expect(params, hasLength(equals(1)));
      expect(params['userId'], equals('234'));
    });
  });
}
