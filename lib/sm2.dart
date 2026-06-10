import 'sm2_response.dart';

/// Calculates SM-2 spaced repetition review intervals.
///
/// `Sm2` is stateless. Store the returned [Sm2Response] values with your card
/// or review item, then pass them back into [calc] on the next review.
class Sm2 {
  /// Calculates the next SM-2 state for one reviewed item.
  ///
  /// Use `repetitions: 0`, `previousInterval: 0`, and
  /// `previousEaseFactor: 2.5` for a new item.
  ///
  /// Throws [ArgumentError] if the input state is outside the SM-2 domain.
  Sm2Response calc({
    /// Recall quality from 0 to 5.
    required int quality,

    /// Number of successful repetitions currently stored for the item.
    required int repetitions,

    /// Last scheduled interval in days.
    required int previousInterval,

    /// Last ease factor for the item.
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
