import 'package:meta/meta.dart';

/// A minimal representation of a file or directory path.
@experimental
@immutable
@sealed
class Path {
  static final _controlChars = RegExp('[\u0000-\u001F\u0080-\u009F]');
  static final _relativePaths = RegExp(r'^\.+(\\|\/)|^\.+$');

  static String _checkFragment(String input) {
    if (input.isEmpty) {
      throw const FormatException('Cannot contain empty fragment');
    }
    if (input.endsWith('.')) {
      throw FormatException('Cannot contain trailing period', input);
    }
    if (_controlChars.hasMatch(input)) {
      final index = _controlChars.matchAsPrefix(input)!.start;
      throw FormatException('Cannot contain control characters', input, index);
    }
    if (_relativePaths.hasMatch(input)) {
      final index = _relativePaths.matchAsPrefix(input)!.start;
      throw FormatException('Cannot contain relative paths', input, index);
    }
    return input;
  }

  /// Fragments that make up the full path.
  ///
  /// Each fragment is expected to be a valid absolute or relative path, and
  /// should not contain characters that are invalid when naming directories
  /// or files.
  final List<String> fragments;

  /// Creates a path object from the provided [fragments].
  ///
  /// The represented path should be legal on all POSIX systems,
  factory Path(Iterable<String> fragments) {
    if (fragments.isEmpty) {
      throw ArgumentError('Expected at least one fragment, got none');
    }
    return Path._fromFragmentsUnchecked(fragments.map(_checkFragment));
  }

  /// A character that otherwise would be invalid.
  static const _sentinelValue = '\u0000{sentinelValue__doNotUse}';

  static List<String> _untilSentinel(List<String> input) {
    final output = <String>[];
    for (final value in input) {
      if (value == _sentinelValue) {
        break;
      }
      output.add(value);
    }
    return output;
  }

  factory Path.of(
    String p1, [
    String p2 = _sentinelValue,
    String p3 = _sentinelValue,
    String p4 = _sentinelValue,
    String p5 = _sentinelValue,
    String p6 = _sentinelValue,
    String p7 = _sentinelValue,
    String p8 = _sentinelValue,
    String p9 = _sentinelValue,
    String p10 = _sentinelValue,
    String p11 = _sentinelValue,
    String p12 = _sentinelValue,
    String p13 = _sentinelValue,
    String p14 = _sentinelValue,
    String p15 = _sentinelValue,
    String p16 = _sentinelValue,
    String p17 = _sentinelValue,
    String p18 = _sentinelValue,
    String p19 = _sentinelValue,
    String p20 = _sentinelValue,
  ]) {
    return Path(_untilSentinel([
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
      p12,
      p13,
      p14,
      p15,
      p16,
      p17,
      p18,
      p19,
      p20,
    ]));
  }

  Path._fromFragmentsUnchecked(Iterable<String> fragments)
      : fragments = List.unmodifiable(fragments);

  @override
  int get hashCode => Object.hashAll(fragments);

  @override
  bool operator ==(Object other) {
    if (other is! Path || fragments.length != other.fragments.length) {
      return false;
    }
    for (var i = 0; i < fragments.length; i++) {
      if (fragments[i] != other.fragments[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() => 'Path <${fragments.join('/')}>';
}
