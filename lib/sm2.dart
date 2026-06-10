import 'sm2_response.dart';

/// Class providing calc function for the SM-2 algorithm.
class Sm2 {
  Sm2Response calc({
    required int quality,
    required int repetitions,
    required int previousInterval,
    required double previousEaseFactor,
  }) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError.value(quality, 'quality', 'must be between 0 and 5');
    }
    if (repetitions < 0) {
      throw ArgumentError.value(repetitions, 'repetitions', 'must be >= 0');
    }
    if (previousInterval < 0) {
      throw ArgumentError.value(
        previousInterval,
        'previousInterval',
        'must be >= 0',
      );
    }
    if (repetitions > 0 && previousInterval < 1) {
      throw ArgumentError.value(
        previousInterval,
        'previousInterval',
        'must be >= 1 when repetitions is greater than 0',
      );
    }
    if (!previousEaseFactor.isFinite || previousEaseFactor < 1.3) {
      throw ArgumentError.value(
        previousEaseFactor,
        'previousEaseFactor',
        'must be finite and >= 1.3',
      );
    }

    int interval;
    if (quality >= 3) {
      switch (repetitions) {
        case 0:
          interval = 1;
          break;
        case 1:
          interval = 6;
          break;
        default:
          interval = (previousInterval * previousEaseFactor).ceil();
      }

      repetitions++;
    } else {
      repetitions = 0;
      interval = 1;
    }

    double easeFactor = previousEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    return Sm2Response(
      interval: interval,
      repetitions: repetitions,
      easeFactor: easeFactor,
    );
  }
}
