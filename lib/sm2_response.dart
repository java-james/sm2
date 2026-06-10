/// Updated SM-2 state after one review.
class Sm2Response {
  /// Number of days until the next review.
  final int interval;

  /// Updated count of successful repetitions.
  final int repetitions;

  /// Updated ease factor, clamped to a minimum of 1.3.
  final double easeFactor;

  /// Creates an immutable SM-2 response.
  Sm2Response({
    required this.interval,
    required this.repetitions,
    required this.easeFactor,
  });
}
