// ignore_for_file: avoid_print

import 'package:spaced_repetition/spaced_repetition.dart';

void main() {
  final result = Sm2().calc(
    quality: 5,
    repetitions: 0,
    previousInterval: 0,
    previousEaseFactor: 2.5,
  );

  print('Next review: ${result.interval} day(s)');
  print('Repetitions: ${result.repetitions}');
  print('Ease factor: ${result.easeFactor}');
}
