/// A minimal POSIX-like file system abstraction.
///
/// The goal is to have a narrow interface into the file system, and to
/// otherwise disallow imports of `dart:io` or `dart:ffi` as part of the build
/// script.
library bagel.src.fs;

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
