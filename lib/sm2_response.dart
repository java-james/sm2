/// Response type from the SM-2 calculation.
class Sm2Response {
  final int interval;
  final int repetitions;
  final double easeFactor;

  Sm2Response({
    required this.interval,
    required this.repetitions,
    required this.easeFactor,
  });
}
