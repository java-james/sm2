# spaced_repetition

A small Dart implementation of the SM-2 spaced repetition algorithm.

SM-2 calculates the next review interval for a piece of knowledge from a 0-5 recall quality score and the item's previous SM-2 state.

## Install

```sh
dart pub add spaced_repetition
```

For Flutter projects:

```sh
flutter pub add spaced_repetition
```

## Quick Start

```dart
import 'package:spaced_repetition/spaced_repetition.dart';

void main() {
  final result = Sm2().calc(
    quality: 5,
    repetitions: 0,
    previousInterval: 0,
    previousEaseFactor: 2.5,
  );

  print(result.interval); // 1
  print(result.repetitions); // 1
  print(result.easeFactor); // 2.6
}
```

Persist the returned values with your card or review item. Pass them back into `calc` the next time that item is reviewed.

```dart
final next = Sm2().calc(
  quality: userScore,
  repetitions: card.repetitions,
  previousInterval: card.interval,
  previousEaseFactor: card.easeFactor,
);

card
  ..interval = next.interval
  ..repetitions = next.repetitions
  ..easeFactor = next.easeFactor
  ..dueAt = DateTime.now().add(Duration(days: next.interval));
```

## API

```dart
Sm2Response calc({
  required int quality,
  required int repetitions,
  required int previousInterval,
  required double previousEaseFactor,
})
```

### Inputs

| Parameter | Type | Description |
| --- | --- | --- |
| `quality` | `int` | Recall quality from `0` to `5`. |
| `repetitions` | `int` | Number of successful repetitions currently stored for the item. Use `0` for a new item. |
| `previousInterval` | `int` | Last scheduled interval in days. Use `0` for a new item. |
| `previousEaseFactor` | `double` | Last ease factor. Use `2.5` for a new item. |

### Outputs

| Field | Type | Description |
| --- | --- | --- |
| `interval` | `int` | Number of days until the next review. |
| `repetitions` | `int` | Updated successful repetition count. |
| `easeFactor` | `double` | Updated ease factor, clamped to a minimum of `1.3`. |

## Quality Scores

SM-2 uses a six-point quality scale:

| Score | Meaning |
| --- | --- |
| `5` | Perfect response. |
| `4` | Correct response after a hesitation. |
| `3` | Correct response recalled with serious difficulty. |
| `2` | Incorrect response where the correct answer seemed easy to recall. |
| `1` | Incorrect response, but the correct answer was remembered. |
| `0` | Complete blackout. |

Scores `3`, `4`, and `5` count as successful reviews. Scores below `3` reset the repetition count and schedule the next review for one day later.

## Valid Input State

`calc` throws `ArgumentError` when inputs are outside the SM-2 domain:

- `quality` must be between `0` and `5`.
- `repetitions` must be `>= 0`.
- `previousInterval` must be `>= 0`.
- `previousInterval` must be `>= 1` when `repetitions > 0`.
- `previousEaseFactor` must be finite and `>= 1.3`.

These checks catch state that the SM-2 algorithm itself cannot produce.

## Algorithm Behavior

This package implements the single-item SM-2 scheduling transition:

1. If `quality >= 3`:
   - `repetitions == 0` schedules `interval = 1`.
   - `repetitions == 1` schedules `interval = 6`.
   - `repetitions > 1` schedules `interval = ceil(previousInterval * previousEaseFactor)`.
   - `repetitions` is incremented.
2. If `quality < 3`:
   - `interval = 1`.
   - `repetitions = 0`.
3. After every review, update the ease factor:

```dart
easeFactor = previousEaseFactor +
    (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
```

4. If `easeFactor < 1.3`, set it to `1.3`.

The official SM-2 description also recommends repeating same-day items that score below `4` until they score at least `4`. This package intentionally provides the single-review calculation only; applications should handle review sessions, persistence, and due-date queues around it.

## Correctness

The implementation follows the official SM-2 recurrence and the published Delphi source for SuperMemo 2. In particular, it updates the ease factor after every review, including failed reviews, and rounds fractional intervals up to the nearest whole day.

## Example App

The `example/` directory contains a small Flutter app that lets you choose quality scores and see how interval, repetitions, and ease factor change over repeated reviews.

```sh
cd example
flutter run
```

## References

- [Official SM-2 algorithm description](https://super-memory.com/english/ol/sm2.htm)
- [Official SM-2 Delphi source](https://super-memory.com/english/ol/sm2source.htm)
- [Spaced repetition on Wikipedia](https://en.wikipedia.org/wiki/Spaced_repetition)

## Development

```sh
dart analyze
dart test
```

To verify the Flutter example:

```sh
cd example
flutter analyze
flutter test
```
