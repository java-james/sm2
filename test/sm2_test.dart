import 'package:flutter_test/flutter_test.dart';
import '../lib/SmResponse.dart';
import '../lib/sm.dart';

void main() {
  test('Calc success', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 0,
      repetitions: 0,
      previousInterval: 0,
      previousEaseFactor: 2.5
    );

    expect(smResponse.interval, 1);
    expect(smResponse.repetitions, 0);
    // Quality 0 should decrease ease factor according to SM-2 formula
    // EF = 2.5 + (0.1 - (5-0) * (0.08 + (5-0) * 0.02)) = 2.5 + (0.1 - 5*0.28) = 1.7
    expect(smResponse.easeFactor, 1.7000000000000002);
  });

  test('Calc - quality: 5, repetitions: 2, interval: 6, factor: 1.3', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 5,
      repetitions: 2,
      previousInterval: 6,
      previousEaseFactor: 1.3
    );

    expect(smResponse.interval, 8);
    expect(smResponse.repetitions, 3);
    expect(smResponse.easeFactor, 1.4000000000000001);
  });

  test('Ease factor calculation for quality < 3 - quality 1', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 1,
      repetitions: 5,
      previousInterval: 30,
      previousEaseFactor: 3.0
    );

    expect(smResponse.interval, 1);
    expect(smResponse.repetitions, 0);
    // EF = 3.0 + (0.1 - (5-1) * (0.08 + (5-1) * 0.02)) = 3.0 + (0.1 - 4*0.2) = 2.46
    expect(smResponse.easeFactor, 2.46);
  });

  test('Ease factor calculation for quality < 3 - quality 2', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 2,
      repetitions: 3,
      previousInterval: 15,
      previousEaseFactor: 2.0
    );

    expect(smResponse.interval, 1);
    expect(smResponse.repetitions, 0);
    // EF = 2.0 + (0.1 - (5-2) * (0.08 + (5-2) * 0.02)) = 2.0 + (0.1 - 3*0.14) = 1.68
    expect(smResponse.easeFactor, 1.68);
  });

  test('Minimum ease factor constraint - quality 0 with low EF', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 0,
      repetitions: 1,
      previousInterval: 6,
      previousEaseFactor: 1.3
    );

    expect(smResponse.interval, 1);
    expect(smResponse.repetitions, 0);
    // EF would be ~0.5 but should be clamped to 1.3
    expect(smResponse.easeFactor, 1.3);
  });

  test('Ease factor calculation for quality >= 3 - unchanged behavior', () {
    final sm = Sm();

    SmResponse smResponse = sm.calc(
      quality: 4,
      repetitions: 1,
      previousInterval: 6,
      previousEaseFactor: 2.5
    );

    expect(smResponse.interval, 6);
    expect(smResponse.repetitions, 2);
    // EF = 2.5 + (0.1 - (5-4) * (0.08 + (5-4) * 0.02)) = 2.5 + (0.1 - 1*0.1) = 2.5
    expect(smResponse.easeFactor, 2.5);
  });
}
