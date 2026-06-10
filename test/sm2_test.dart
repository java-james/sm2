import 'package:spaced_repetition/spaced_repetition.dart';
import 'package:test/test.dart';

void main() {
  group('Sm2.calc', () {
    test('schedules the first successful review after one day', () {
      final response = Sm2().calc(
        quality: 5,
        repetitions: 0,
        previousInterval: 0,
        previousEaseFactor: 2.5,
      );

      expect(response.interval, 1);
      expect(response.repetitions, 1);
      expect(response.easeFactor, closeTo(2.6, 0.0000000001));
    });

    test('schedules the second successful review after six days', () {
      final response = Sm2().calc(
        quality: 4,
        repetitions: 1,
        previousInterval: 1,
        previousEaseFactor: 2.6,
      );

      expect(response.interval, 6);
      expect(response.repetitions, 2);
      expect(response.easeFactor, closeTo(2.6, 0.0000000001));
    });

    test('multiplies later successful intervals by the previous ease factor',
        () {
      final response = Sm2().calc(
        quality: 5,
        repetitions: 2,
        previousInterval: 6,
        previousEaseFactor: 1.3,
      );

      expect(response.interval, 8);
      expect(response.repetitions, 3);
      expect(response.easeFactor, closeTo(1.4, 0.0000000001));
    });

    test('rounds fractional intervals up to the nearest integer', () {
      final response = Sm2().calc(
        quality: 4,
        repetitions: 2,
        previousInterval: 6,
        previousEaseFactor: 1.4,
      );

      expect(response.interval, 9);
      expect(response.repetitions, 3);
      expect(response.easeFactor, closeTo(1.4, 0.0000000001));
    });

    test('resets repetitions and interval after an incorrect response', () {
      final response = Sm2().calc(
        quality: 2,
        repetitions: 4,
        previousInterval: 20,
        previousEaseFactor: 2.5,
      );

      expect(response.interval, 1);
      expect(response.repetitions, 0);
    });

    test('updates ease factor for every quality grade', () {
      final sm2 = Sm2();

      expect(
        sm2
            .calc(
              quality: 0,
              repetitions: 0,
              previousInterval: 0,
              previousEaseFactor: 2.5,
            )
            .easeFactor,
        closeTo(1.7, 0.0000000001),
      );
      expect(
        sm2
            .calc(
              quality: 1,
              repetitions: 0,
              previousInterval: 0,
              previousEaseFactor: 2.5,
            )
            .easeFactor,
        closeTo(1.96, 0.0000000001),
      );
      expect(
        sm2
            .calc(
              quality: 2,
              repetitions: 0,
              previousInterval: 0,
              previousEaseFactor: 2.5,
            )
            .easeFactor,
        closeTo(2.18, 0.0000000001),
      );
      expect(
        sm2
            .calc(
              quality: 3,
              repetitions: 0,
              previousInterval: 0,
              previousEaseFactor: 2.5,
            )
            .easeFactor,
        closeTo(2.36, 0.0000000001),
      );
    });

    test('does not let ease factor fall below 1.3', () {
      final response = Sm2().calc(
        quality: 0,
        repetitions: 0,
        previousInterval: 0,
        previousEaseFactor: 1.4,
      );

      expect(response.easeFactor, 1.3);
    });

    test('rejects quality grades outside the SM-2 scale', () {
      expect(
        () => Sm2().calc(
          quality: -1,
          repetitions: 0,
          previousInterval: 0,
          previousEaseFactor: 2.5,
        ),
        throwsArgumentError,
      );
      expect(
        () => Sm2().calc(
          quality: 6,
          repetitions: 0,
          previousInterval: 0,
          previousEaseFactor: 2.5,
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid repetition state', () {
      expect(
        () => Sm2().calc(
          quality: 5,
          repetitions: -1,
          previousInterval: 0,
          previousEaseFactor: 2.5,
        ),
        throwsArgumentError,
      );
      expect(
        () => Sm2().calc(
          quality: 5,
          repetitions: 0,
          previousInterval: -1,
          previousEaseFactor: 2.5,
        ),
        throwsArgumentError,
      );
      expect(
        () => Sm2().calc(
          quality: 5,
          repetitions: 1,
          previousInterval: 0,
          previousEaseFactor: 2.5,
        ),
        throwsArgumentError,
      );
      expect(
        () => Sm2().calc(
          quality: 5,
          repetitions: 0,
          previousInterval: 0,
          previousEaseFactor: 1.2,
        ),
        throwsArgumentError,
      );
    });
  });
}
