import 'package:bagel/src/fs.dart';
import 'package:test/test.dart';

void main() {
  group('Path', () {
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
          () => Path(const ['']),
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
          () => Path(const ['foo.']),
          throwsA(
            isFormatException.having(
              (a) => a.toString(),
              'error',
              contains('Cannot contain trailing period'),
            ),
          ),
        );
      });

      test('control characters', () {
        expect(
          () => Path(const ['foo.']),
          throwsA(
            isFormatException.having(
              (a) => a.toString(),
              'error',
              contains('Cannot contain trailing period'),
            ),
          ),
        );
      });
    });
  });
}
