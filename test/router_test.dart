library corsac_router.test;

import 'package:test/test.dart';
import 'package:corsac_router/corsac_router.dart';

void main() {
  group("Router", () {
    test("it matches to a route", () {
      HttpResource r = new HttpResource('/users', ['GET']);

      Router router = new Router();
      router.resources[r] = 'test';

      var result = router.match(Uri.parse('/users'), 'GET');

      expect(result, new isInstanceOf<MatchResult>());
      expect(result.hasMatch, isTrue);
      expect(result.resource, same(r));
      expect(result.data, equals('test'));
      expect(result.parameters, isMap);
      expect(result.parameters, isEmpty);
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
