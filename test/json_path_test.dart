import 'package:json_pointer/json_pointer.dart' as jp;
import 'package:test/test.dart';

void main() {
  group('Tests', () {

    test('Compose 1', () {
      expect(jp.compose(['one', 'two']), '/one/two');
    });

    test('Compose 2', () {
      expect(jp.compose(['one/two']), '/one~1two');
    });

    test('Compose 3', () {
      expect(jp.compose([]), '');
    });

    test('Compose 4', () {
      expect(jp.compose(['', '', '']), '///');
    });

    test('Split 1', () {
      expect(jp.split('/one/two'), ['one', 'two']);
    });

    test('Split 2', () {
      expect(jp.split('/one~1two'), ['one/two']);
    });

    test('Split 3', () {
      expect(jp.split(''), []);
    });

    test('Split 4', () {
      expect(jp.split('///'), ['', '', '']);
    });


    test('Parent 1', () {
      expect(jp.parent('/one/two'), '/one');
    });

    test('Parent 2', () {
      expect(jp.parent('/one'), '');

    });
    test('Parent 3', () {
      expect(jp.parent(''), null);
    });

    test('append 1', () {
      expect(jp.append('/one', 'two'), '/one/two');
    });

    test('append 2', () {
      expect(jp.append('/one', '~'), '/one/~0');
    });


    test('get\$ 1', () {
      expect(jp.get$('', [{'foo': 'bar'}]), [{'foo': 'bar'}]);
    });
    test('get\$ 2', () {
      expect(jp.get$('/0', [{'foo': 'bar'}]), {'foo': 'bar'});
    });
    test('get\$ 3', () {
      expect(jp.get$('/0/foo', [{'foo': 'bar'}]), 'bar');
    });
    
    test('set\$ 1', () {
      expect(jp.set$('', [{'foo': 'bar'}, 2], 'baz'), 'baz');
    });
    test('set\$ 2', () {
      expect(jp.set$('/0', [{'foo': 'bar'}, 2], 'baz'), ['baz', 2]);
    });
    test('set\$ 3', () {
      expect(jp.set$('/0/foo', [{'foo': 'bar'}], 'baz'), [{'foo': 'baz'}]);
    });

    
    test('contains 1', () {
      expect(jp.contains('', [{'foo': 'bar'}]), true);
    });
    test('contains 2', () {
      expect(jp.contains('/0', [{'foo': 'bar'}]), true);
    });
    test('contains 3', () {
      expect(jp.contains('/0/foo', [{'foo': 'bar'}]), true);
    });

    test('contains 4', () {
      expect(jp.contains('/a/5', [{'foo': 'bar'}]), false);
    });
    test('contains 5', () {
      expect(jp.contains('/1', [{'foo': 'bar'}]), false);
    });
    test('contains 6', () {
      expect(jp.contains('/0/foo/baz', [{'foo': 'bar'}]), false);
    });

    
    test('escape 1', () {
      expect(jp.escape('one/two'), 'one~1two');
    });
    test('escape 2', () {
      expect(jp.escape('name'), 'name');
    });

    
    test('escape / unescape', () {
      var orig = '~~//~/~01~111~00~010011';
      expect(jp.unescape(jp.escape(orig)), orig);
    });

    test('unescape 1', () {
      expect(jp.unescape('name'), 'name');
    });

    
    test('unescape 2', () {
      expect(jp.unescape('one~1two'), 'one/two');
    });

    
    test('isValid 1', () {
      expect(jp.isValid('/one/two'), true);
    });

    test('isValid 2', () {
      expect(jp.isValid(''), true);
    });

    test('isValid 3', () {
      expect(jp.isValid('/one~1two'), true);
    });


    test('isValid 4', () {
      expect(jp.isValid(null), false);
    });

    test('isValid 5', () {
      expect(jp.isValid('/~2'), false);
    });

    test('isValid 6', () {
      expect(jp.isValid('0/foo'), false);
    });





  });
}
