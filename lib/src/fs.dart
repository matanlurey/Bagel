/// A minimal POSIX-like file system abstraction.
///
/// The goal is to have a narrow interface into the file system, and to
/// otherwise disallow imports of `dart:io` or `dart:ffi` as part of the build
/// script.
library bagel.src.fs;

export '/src/fs/path.dart' show Path;
