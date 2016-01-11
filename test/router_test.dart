library corsac_router.test.router;

import 'package:test/test.dart';
import 'package:corsac_router/corsac_router.dart';

void main() {
  group("Router", () {
    test("it matches to a route", () {
      HttpResource r =
          new HttpResource('/users', ['GET'], attributes: {#version: '1'});

      Router router = new Router();
      router.resources[r] = 'test';

      var result =
          router.match(Uri.parse('/users'), 'GET', attributes: {#version: '1'});

      expect(result, new isInstanceOf<MatchResult>());
      expect(result.hasMatch, isTrue);
      expect(result.resource, same(r));
      expect(result.data, equals('test'));
      expect(result.parameters, isMap);
      expect(result.parameters, isEmpty);
      expect(result.attributes, isMap);
      expect(result.attributes[#version], equals('1'));
    });

    test("it matches to a null when no route found", () {
      HttpResource r = new HttpResource('/users', ['GET']);

      Router router = new Router();
      router.resources[r] = 'test';

      var result = router.match(Uri.parse('/nope'), 'GET');

      expect(result, new isInstanceOf<MatchResult>());
      expect(result.hasMatch, isFalse);
      expect(result.resource, isNull);
      expect(result.data, isNull);
      expect(result.parameters, isNull);
    });
  });
}
