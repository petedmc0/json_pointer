import 'package:json_pointer/json_pointer.dart';

main() {
  
  compose(['one', 'two']); // '/one/two'
  compose(['one/two']); // '/one~1two'
  compose([]); // ''
  compose(['', '', '']); // '///'

  // Split is the opposite of compose
  split('/one/two'); // ['one', 'two']
  split('/one~1two'); // ['one/two'] 
  split(''); // []
  split('///'); // ['', '', '']

  // Other helpers
  parent('/one/two'); // '/one'
  parent('/one'); // ''
  parent(''); // null

  append('/one', 'two'); // '/one/two'
  append('/one', '~');   // '/one/~0'  append escapes the appended item 


  // Get and Set values
  get$('', [{'foo': 'bar'}]); // [{'foo': 'bar'}]
  get$('/0', [{'foo': 'bar'}]); // {'foo': 'bar'}
  get$('/0/foo', [{'foo': 'bar'}]); // 'bar'

  set$('', [{'foo': 'bar'}], 'baz'); // 'baz'
  set$('/0', [{'foo': 'bar'}], 'baz'); // ['baz']
  set$('/0/foo', [{'foo': 'bar'}], 'baz'); // [{'foo': 'baz'}]

  // Contains
  contains('', [{'foo': 'bar'}]); // true
  contains('/0', [{'foo': 'bar'}]); // true
  contains('/0/foo', [{'foo': 'bar'}]); // true

  contains('/a/5', [{'foo': 'bar'}]); // false
  contains('/1', [{'foo': 'bar'}]); // false
  contains('/0/foo/baz', [{'foo': 'bar'}]); // false

  // Escape part of a path
  escape('one/two'); // 'one~1two'
  escape('name'); // 'name'

  unescape('name'); // 'name'
  unescape('one~1two'); // 'one/two'

  // Validation
  isValid('/one/two'); // true
  isValid(''); // true
  isValid('/one~1two'); // true

  isValid(null); // false: null pointer
  isValid('/~2'); // false: '~' must be followed by either '0' or '1'
  isValid('0/foo'); // false: should start with '/'
}
