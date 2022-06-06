import 'package:bagel/src/fs.dart';
import 'package:test/test.dart';

void main() {
  group('Path', () {
    test('.of should work like varargs', () {
      for (var i = 0; i < 20; i++) {
        final fragments = List.generate(
          i + 1,
          (index) => String.fromCharCode('a'.codeUnitAt(0) + index),
        );
        expect(Function.apply(Path.of, fragments), Path(fragments));
      }
    });

    test('should accept a valid path', () {
      expect(Path.of('README.md'), Path.of('README.md'));
      expect(Path.of('build_config'), Path.of('build_config'));
      expect(Path.of('foo', 'bar'), Path.of('foo', 'bar'));
    });

    group('should reject', () {
      test('an empty path', () {
        expect(
          () => Path(const []),
          throwsA(
            isArgumentError.having(
              (a) => a.toString(),
              'error',
              contains('Expected at least one fragment'),
            ),
          ),
        );
      });

      test('an empty fragment', () {
        expect(
          () => Path.of(''),
          throwsA(
            isFormatException.having(
              (a) => a.toString(),
              'error',
              contains('Cannot contain empty fragment'),
            ),
          ),
        );
      });

      test('a trailing period', () {
        expect(
          () => Path.of('foo.'),
          throwsA(
            isFormatException.having(
              (a) => a.toString(),
              'error',
              contains('Cannot contain trailing period'),
            ),
          ),
        );
      });

      group('control characters', () {
        final throwsHavingControlCharacters = throwsA(
          isFormatException.having(
            (a) => a.toString(),
            'error',
            contains('Cannot contain control characters'),
          ),
        );

        test('\\u0000', () {
          expect(() => Path.of('\u0000'), throwsHavingControlCharacters);
        });

        test('\\u001F', () {
          expect(() => Path.of('\u001F'), throwsHavingControlCharacters);
        });

        test('\\u0080', () {
          expect(() => Path.of('\u0080'), throwsHavingControlCharacters);
        });

        test('\\u009F', () {
          expect(() => Path.of('\u009F'), throwsHavingControlCharacters);
        });
      });

      test('relative paths', () {
        expect(
          () => Path.of('../'),
          throwsA(
            isFormatException.having(
              (a) => a.toString(),
              'error',
              contains('Cannot contain relative paths'),
            ),
          ),
        );
      });
    });
  });
}
