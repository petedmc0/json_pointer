import 'pointer_format_error.dart';
import 'bad_route_error.dart';
import 'part_format_error.dart';

/// Creates a json pointer from a list of parts.  Each part is escaped.
/// ```
/// compose(['one', 'two']) == '/one/two'
/// ```
String compose(List<String> parts) {
  return parts.map((p) => "/${escape(p)}").join();
}

/// Splits a json pointer into a list of parts.  Each part is unescaped.
/// ```
/// split('/one/two') == ['one', 'two']
/// ```
List<String> split(String pointer) {
  // Note, can't use the built in string.split function because
  // it doesn't handle zero length matches properly
  _validate(pointer);
  return _partRe.allMatches(pointer).map((m) => unescape(m.group(1))).toList();
}

/// Returns the parent of [pointer].  Returns null if [pointer] == ""
/// ```
/// parent('/one/two') == '/one'
/// ```
String parent(String pointer) {
  _validate(pointer);
  if (pointer == "") {
    return null;
  } else {
    var i = pointer.lastIndexOf("/");
    return pointer.substring(0, i);
  }
}

/// Appends a single [part] onto the pointer.  The part is escaped before adding.
/// ```
/// append('/one/two', 'three') == '/one/two/three'
/// ```
String append(String pointer, String part) {
  _validate(pointer);
  return "$pointer/${escape(part)}";
}

/// Gets the element of [json] referenced by [pointer].
/// ```
/// get$('/0/foo', [{'foo': 'bar'}]) == 'bar'
/// ```
dynamic get$(String pointer, dynamic json) {
  _validate(pointer);

  // Special case, path is root
  if (pointer.isEmpty) {
    return json;
  }

  var a = _findAccessor(pointer, json);
  if (a == null) throw BadRouteError(pointer);
  return _findAccessor(pointer, json).child;
}

/// set the element of [json] referenced by [pointer] to [value]
/// ```
/// set$('/0', [0, 1], 25) == [25, 1]
/// ```
dynamic set$(String pointer, dynamic json, dynamic value) {
  _validate(pointer);

  // Special case, path is root
  if (pointer.isEmpty) {
    return value;
  }

  var a = _findAccessor(pointer, json);
  if (a == null) throw BadRouteError(pointer);
  a.child = value;
  return json;
}

/// returns true if [json] contains an object referenced by [pointer].
/// ```
/// contains('/1', [0, 1]) == true
/// ```
dynamic contains(String pointer, dynamic json) {
  _validate(pointer);

  // Special case, path is root
  if (pointer.isEmpty) {
    return true;
  }

  var a = _findAccessor(pointer, json);
  return a != null;
}

/// Unescapes the characters '\~0' and '\~1' with '\~' and '/' respectively.
String unescape(String part) {
  _validatePart(part);
  return part.replaceAll("~1", "/").replaceAll("~0", "~");
}

/// Returns true if [pointer] is a properly formated json pointer
bool isValid(String pointer) {
  if (pointer == null) {
    return false;
  } else if (_tildeNotFollowedBy0Or1.hasMatch(pointer)) {
    return false;
  } else if (pointer.isNotEmpty && pointer[0] != '/') {
    return false;
  }
  return true;
}

bool _isPartValid(String part) {
  if (part == null) {
    return false;
  } else if (_tildeNotFollowedBy0Or1.hasMatch(part)) {
    return false;
  } else if (part.contains("/")) {
    return false;
  }
  return true;
}

_Accessor _findAccessor(String pointer, dynamic json) {
  var parts = split(pointer);
  assert(parts.isNotEmpty);
  _Accessor result;

  for (var p in parts) {
    if (json is Map) {
      if (json.containsKey(p)) {
        result = _KeyMap(p, json);
        json = result.child;
        continue;
      }
    }

    if (json is List) {
      var i = int.tryParse(p);
      if (i != null && 0 <= i && i < json.length) {
        result = _IndexList(i, json);
        json = result.child;
        continue;
      }
    }

    return null;
  }

  return result;
}

/// Escapes the characters '\~' and '/' with '\~0' and '\~1' respectively.
String escape(String part) {
  return part.replaceAll("~", "~0").replaceAll("/", "~1");
}

void _validate(String pointer) {
  if (!isValid(pointer)) {
    throw PointerFormatError(pointer);
  }
}

void _validatePart(String part) {
  if (!_isPartValid(part)) {
    throw PartFormatError(part);
  }
}

final _tildeNotFollowedBy0Or1 = RegExp("~(?![01])");

/// This matches '/' followed zero or more not '/'
final _partRe = RegExp(r"\/([^\/]*)");

abstract class _Accessor {
  dynamic get child;
  set child(dynamic value);
}

class _KeyMap extends _Accessor {
  final String key;
  final Map map;
  _KeyMap(this.key, this.map);

  @override
  set child(value) {
    map[key] = value;
  }

  @override
  get child => map[key];
}

class _IndexList extends _Accessor {
  final int index;
  final List list;
  _IndexList(this.index, this.list);

  @override
  set child(value) {
    list[index] = value;
  }

  @override
  get child => list[index];
}
