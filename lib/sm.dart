import './SmResponse.dart';

/// Class providing calc function
class Sm {
  SmResponse calc({
    required int quality,
    required int repetitions,
    required int previousInterval,
    required double previousEaseFactor,
  }) {
    int interval;
    double easeFactor;
    
    // Always calculate ease factor using SM-2 formula, regardless of quality
    easeFactor = previousEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    if (quality >= 3) {
      switch (repetitions) {
        case 0:
          interval = 1;
          break;
        case 1:
          interval = 6;
          break;
        default:
          interval = (previousInterval * previousEaseFactor).round();
      }

      repetitions++;
    } else {
      repetitions = 0;
      interval = 1;
    }

    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    return SmResponse(
        interval: interval, repetitions: repetitions, easeFactor: easeFactor);
  }
}
