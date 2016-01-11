library corsac_router.test.resource;

import 'package:test/test.dart';
import 'package:corsac_router/corsac_router.dart';

void main() {
  group("Resource", () {
    test("it matches static route", () {
      HttpResource r = new HttpResource('/users', ['GET']);
      expect(r.matches(Uri.parse('/users'), httpMethod: 'GET'), isTrue);
      expect(r.matches(Uri.parse('/users'), httpMethod: 'get'), isTrue);
      expect(r.matches(Uri.parse('/users'), httpMethod: 'POST'), isFalse);
      expect(r.matches(Uri.parse('/users?status=active'), httpMethod: 'GET'),
          isTrue);
      expect(r.matches(Uri.parse('/users/'), httpMethod: 'GET'), isFalse);
      expect(r.matches(Uri.parse('/users/1'), httpMethod: 'GET'), isFalse);
    });

    test("it matches only route without HTTP method", () {
      HttpResource r = new HttpResource('/users', ['GET']);
      expect(r.matches(Uri.parse('/users')), isTrue);
    });

    test("it matches route with parameter", () {
      HttpResource r = new HttpResource('/users/{userId}', ['GET']);
      expect(r.matches(Uri.parse('/users/234'), httpMethod: 'GET'), isTrue);
      expect(
          r.matches(Uri.parse('/users/324?status=active'), httpMethod: 'GET'),
          isTrue);
      expect(r.matches(Uri.parse('/users/'), httpMethod: 'GET'), isFalse);
      expect(r.matches(Uri.parse('/users/123/'), httpMethod: 'GET'), isFalse);
      expect(
          r.matches(Uri.parse('/users/123/baz'), httpMethod: 'GET'), isFalse);
    });

    test("it extracts route parameters", () {
      HttpResource r = new HttpResource('/users/{userId}', ['GET']);
      var params = r.resolveParameters(Uri.parse('/users/234'));
      expect(params, isMap);
      expect(params, hasLength(equals(1)));
      expect(params['userId'], equals('234'));
    });

    test('it matches only when attributes match', () {
      HttpResource r =
          new HttpResource('/users', ['GET'], attributes: {#version: '1'});
      expect(r.matches(Uri.parse('/users')), isFalse);
      expect(
          r.matches(Uri.parse('/users'), attributes: {#version: 1}), isFalse);
      expect(
          r.matches(Uri.parse('/users'), attributes: {#version: '1'}), isTrue);
    });

    test('equality', () {
      var r1 = new HttpResource('/users', ['GET'], attributes: {#version: '1'});
      var r2 = new HttpResource('/users', ['GET'], attributes: {#version: '1'});
      var r3 = new HttpResource('/users', ['GET']);
      var r4 = new HttpResource('/users', ['GET'], attributes: {#version: '2'});
      var r5 = new HttpResource('/users', ['GET'], attributes: {#otherke: '1'});
      var r6 = new HttpResource('/users', ['PUT'], attributes: {#version: '1'});
      var r7 = new HttpResource('/posts', ['GET'], attributes: {#version: '1'});
      var r8 = new HttpResource('/users', ['get'], attributes: {#version: '1'});

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1, isNot(equals(r4)));
      expect(r1, isNot(equals(r5)));
      expect(r1, isNot(equals(r6)));
      expect(r1, isNot(equals(r7)));
      expect(r1, equals(r8));
    });
  });
}
