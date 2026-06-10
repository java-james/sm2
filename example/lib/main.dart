import 'package:flutter/material.dart';
import 'package:spaced_repetition/spaced_repetition.dart';

void main() {
  runApp(const SpacedRepetitionExample());
}

class SpacedRepetitionExample extends StatelessWidget {
  const SpacedRepetitionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaced Repetition',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  static const _initialEaseFactor = 2.5;

  int _interval = 0;
  int _repetitions = 0;
  double _easeFactor = _initialEaseFactor;
  int? _lastQuality;

  void _review(int quality) {
    final response = Sm().calc(
      quality: quality,
      repetitions: _repetitions,
      previousInterval: _interval,
      previousEaseFactor: _easeFactor,
    );

    setState(() {
      _interval = response.interval;
      _repetitions = response.repetitions;
      _easeFactor = response.easeFactor;
      _lastQuality = quality;
    });
  }

  void _reset() {
    setState(() {
      _interval = 0;
      _repetitions = 0;
      _easeFactor = _initialEaseFactor;
      _lastQuality = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaced Repetition'),
        actions: [
          IconButton(
            onPressed: _reset,
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Review result', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            _ResultRow(label: 'Next interval', value: '$_interval days'),
            _ResultRow(label: 'Repetitions', value: '$_repetitions'),
            _ResultRow(
              label: 'Ease factor',
              value: _easeFactor.toStringAsFixed(2),
            ),
            _ResultRow(
              label: 'Last quality',
              value: _lastQuality?.toString() ?? 'Not reviewed',
            ),
            const SizedBox(height: 32),
            Text(
              'How well did you remember it?',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final quality in [0, 1, 2, 3, 4, 5])
                  FilledButton.tonal(
                    onPressed: () => _review(quality),
                    child: Text('$quality'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
