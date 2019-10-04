# JSON Pointer

A simple library for creating and using json-pointer (See [rfc6901](https://tools.ietf.org/html/rfc6901)).

## Examples

```Dart
  // Json Pointer Manipulation
  compose(['one', 'two']); // '/one/two'
  split('/one/two'); // ['one', 'two']
  parent('/one/two'); // '/one'
  last('/one/two/three'); // 'three'
  append('/one/two', 'three'); // '/one/two/three'
  isValid('/one/two'); // true

  // Json Pointer Part manipulation
  escape('one/two'); // 'one~1two'
  unescape('one~1two'); // 'one/two'

  // Get and Set values in a json object
  var obj = [
    {'foo': 'bar'}
  ]

  get$('/0/foo', obj); // 'bar'
  set$('/0/foo', obj, 'baz'); // [{'foo': 'baz'}]
  contains('/0/foo', obj); // true
```

## Escaping Examples

```Dart
  // Compose escapes parts
  compose(['one/two', 'three']); // '/one~1two/three'

  // Append escapes the added part
  append('/one', 'two/three'); // '/one/two~1three'

  // Last unescapes the returned part
  last('/one/two~1three'); // 'two/three'

  // Split unescapes parts
  split('/one~1two/three'); // ['one/two', 'three']
```

## Traversal

The library is only able to traverse through objects of type `Map` and `List`.  Functions will generally throw `BadRouteError` when attempting to traverse other types.  `contains` will return false.

```Dart
class Point {
  Point(this.x, this.y);
  int x;
  int y;
}

contains('/x', Point(0, 0)) // false
contains('', Point(0, 0)) // true, this is ok as Point is never traversed 
```

