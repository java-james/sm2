# SM-2 Spaced Repetition Flutter Package

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Alternative: Working with Dart SDK Only

If Flutter SDK installation fails or is unavailable, you can perform basic validation using just the Dart SDK:

### Install Dart SDK Only
```bash
cd /tmp
wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.8.0/sdk/dartsdk-linux-x64-release.zip
unzip -q dartsdk-linux-x64-release.zip
export PATH="/tmp/dart-sdk/bin:$PATH"
dart --version
```

### Basic Validation Commands (Dart SDK Only)
- **Syntax Analysis** (Very fast - <1 second):
  ```bash
  cd /home/runner/work/sm2/sm2
  export PATH="/tmp/dart-sdk/bin:$PATH"
  dart analyze lib/
  ```

- **Format Check**:
  ```bash
  cd /home/runner/work/sm2/sm2
  export PATH="/tmp/dart-sdk/bin:$PATH"
  dart format --set-exit-if-changed lib/
  ```
  - **Verified**: This command will format the code and exit with error code 1 if changes were made
  - Always run `dart format lib/` before committing to ensure consistent formatting

**Note**: Testing and Flutter-specific operations require the full Flutter SDK.

## Working Effectively

### Initial Setup (CRITICAL - Do these steps in order)
1. **Install Flutter SDK** (NEVER CANCEL - This may take 15-20 minutes):
   ```bash
   cd /tmp
   git clone https://github.com/flutter/flutter.git -b stable --depth 1
   export PATH="/tmp/flutter/bin:$PATH"
   flutter doctor
   ```
   - **TIMING**: Git clone takes 3-5 minutes, `flutter doctor` initial setup takes 10-15 minutes
   - **NEVER CANCEL** the Flutter installation process even if it appears to hang
   - Set timeout to 30+ minutes for initial Flutter setup

2. **Get Dependencies for Main Package** (NEVER CANCEL - Takes 2-5 minutes):
   ```bash
   cd /home/runner/work/sm2/sm2
   export PATH="/tmp/flutter/bin:$PATH"
   flutter pub get
   ```

3. **Get Dependencies for Example App** (NEVER CANCEL - Takes 2-5 minutes):
   ```bash
   cd /home/runner/work/sm2/sm2/example
   export PATH="/tmp/flutter/bin:$PATH"
   flutter pub get
   ```

### Build and Test Commands

#### Main Package Operations
- **Run Tests** (NEVER CANCEL - Takes 1-3 minutes):
  ```bash
  cd /home/runner/work/sm2/sm2
  export PATH="/tmp/flutter/bin:$PATH"
  flutter test
  ```
  - Set timeout to 10+ minutes
  - Tests validate the SM-2 algorithm implementation

- **Analyze Code** (Takes 10-30 seconds):
  ```bash
  cd /home/runner/work/sm2/sm2
  export PATH="/tmp/flutter/bin:$PATH"
  flutter analyze
  ```
  - **Validated**: `dart analyze lib/` completes in under 1 second for this codebase
  - Use `dart analyze` as alternative if Flutter is not available

- **Validate Package for Publishing** (Takes 1-2 minutes):
  ```bash
  cd /home/runner/work/sm2/sm2
  export PATH="/tmp/flutter/bin:$PATH"
  flutter pub publish --dry-run
  ```

#### Example Application Operations
- **Run Example App** (Web - NEVER CANCEL - Takes 3-8 minutes for first build):
  ```bash
  cd /home/runner/work/sm2/sm2/example
  export PATH="/tmp/flutter/bin:$PATH"
  flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
  ```
  - **CRITICAL**: First build can take 5-10 minutes. NEVER CANCEL.
  - Set timeout to 20+ minutes for first web build
  - Subsequent builds are faster (1-2 minutes)

- **Build Example for Web** (NEVER CANCEL - Takes 3-8 minutes):
  ```bash
  cd /home/runner/work/sm2/sm2/example
  export PATH="/tmp/flutter/bin:$PATH"
  flutter build web
  ```
  - Set timeout to 15+ minutes
  - Output goes to `example/build/web/`

- **Build Example APK** (NEVER CANCEL - Takes 10-15 minutes):
  ```bash
  cd /home/runner/work/sm2/sm2/example
  export PATH="/tmp/flutter/bin:$PATH"
  flutter build apk
  ```
  - **WARNING**: Requires Android SDK setup
  - Set timeout to 30+ minutes for first build
  - May fail without Android development tools

## Validation Requirements

### ALWAYS Test After Changes
1. **Run the test suite**:
   ```bash
   cd /home/runner/work/sm2/sm2
   export PATH="/tmp/flutter/bin:$PATH"
   flutter test
   ```

3. **Validate with flutter analyze and format**:
   ```bash
   cd /home/runner/work/sm2/sm2
   export PATH="/tmp/flutter/bin:$PATH"
   flutter format lib/ test/ example/lib/
   flutter analyze
   ```
   - Format must not make changes (run format before committing)
   - Analyze must pass with no errors or warnings before committing

3. **Test Example App Functionality**:
   - Build and run the example web app
   - Verify the SM-2 algorithm calculation displays correctly
   - Test with different quality values (0-5) to ensure proper interval calculation
   - Check that repetitions increment and ease factor adjusts properly

### Manual Validation Scenarios
After making changes to the SM-2 algorithm (`lib/sm.dart`), ALWAYS test these scenarios:

1. **Incorrect Response (quality < 3)**:
   - Input: quality=0, repetitions=5, interval=10, ease=2.0
   - Expected: repetitions=0, interval=1, ease=2.0 (unchanged)

2. **First Review (quality ≥ 3, repetitions=0)**:
   - Input: quality=4, repetitions=0, interval=0, ease=2.5
   - Expected: repetitions=1, interval=1, ease adjusted

3. **Second Review (quality ≥ 3, repetitions=1)**:
   - Input: quality=4, repetitions=1, interval=1, ease=2.5
   - Expected: repetitions=2, interval=6, ease adjusted

4. **Subsequent Reviews (quality ≥ 3, repetitions > 1)**:
   - Input: quality=5, repetitions=2, interval=6, ease=1.3
   - Expected: repetitions=3, interval=8, ease adjusted

## Repository Structure and Navigation

### Key Files and Directories
```
/home/runner/work/sm2/sm2/
├── lib/
│   ├── main.dart           # Package exports
│   ├── sm.dart            # Core SM-2 algorithm implementation
│   └── SmResponse.dart    # Response model class
├── test/
│   └── sm2_test.dart      # Unit tests for algorithm
├── example/
│   ├── lib/main.dart      # Example Flutter app
│   └── pubspec.yaml       # Example app dependencies
├── pubspec.yaml           # Main package configuration
├── README.md              # Algorithm documentation
└── CHANGELOG.md           # Version history
```

### Most Frequently Modified Files
- **`lib/sm.dart`**: Core algorithm - modify when changing SM-2 logic
- **`test/sm2_test.dart`**: Add tests when modifying algorithm behavior
- **`example/lib/main.dart`**: Modify to demonstrate new features
- **`pubspec.yaml`**: Update when changing dependencies or version

### When Making Changes
1. **Algorithm Changes**: Always modify `lib/sm.dart` and add corresponding tests in `test/sm2_test.dart`
2. **Model Changes**: Update `lib/SmResponse.dart` and ensure all references are updated
3. **Example Changes**: Update `example/lib/main.dart` to demonstrate new functionality
4. **Version Updates**: Update version in `pubspec.yaml` and add entry to `CHANGELOG.md`

## Common Issues and Solutions

### Flutter SDK Issues
- **Problem**: `flutter: command not found`
- **Solution**: Ensure Flutter is in PATH: `export PATH="/tmp/flutter/bin:$PATH"`

### Dependency Issues  
- **Problem**: "Version solving failed"
- **Solution**: Run `flutter pub get` in both main directory and `example/` directory

### Build Failures
- **Problem**: Web build fails
- **Solution**: Enable web: `flutter config --enable-web`
- **Problem**: Android build fails  
- **Solution**: Install Android SDK or focus on web/testing only

### Test Failures
- **Problem**: Floating point comparison issues
- **Solution**: Use `expect(value, closeTo(expected, 0.0001))` for double comparisons

## Performance Expectations

### Build Times (First Time)
- **Flutter SDK Setup**: 15-20 minutes - NEVER CANCEL
- **flutter pub get**: 2-5 minutes - NEVER CANCEL  
- **flutter test**: 1-3 minutes
- **flutter analyze**: 30 seconds - 2 minutes
- **flutter build web**: 5-10 minutes - NEVER CANCEL (set 20+ minute timeout)
- **flutter run -d web**: 3-8 minutes first time - NEVER CANCEL

### Build Times (Subsequent)
- **flutter pub get**: 30 seconds - 2 minutes
- **flutter test**: 30 seconds - 1 minute  
- **flutter analyze**: 10-30 seconds (verified: <1 second for this codebase)
- **flutter build web**: 1-3 minutes
- **flutter run -d web**: 1-2 minutes

### CRITICAL Timeout Settings
- **Initial Flutter setup**: Set 30+ minute timeout, NEVER CANCEL
- **First web build**: Set 20+ minute timeout, NEVER CANCEL
- **All pub get operations**: Set 10+ minute timeout, NEVER CANCEL
- **Test runs**: Set 10+ minute timeout
- **Analyze operations**: Set 5+ minute timeout

## Algorithm Details

This package implements the SM-2 spaced repetition algorithm with these key behaviors:
- **Quality 0-2**: Reset repetitions to 0, interval to 1, keep ease factor unchanged
- **Quality 3-5**: Increment repetitions, calculate new interval, adjust ease factor
- **Minimum ease factor**: 1.3 (algorithm enforces this lower bound)
- **First review**: Always sets interval to 1 day
- **Second review**: Always sets interval to 6 days  
- **Subsequent reviews**: interval = previous_interval × ease_factor (rounded up)

## Example Command Reference

### Quick Validation After Changes
```bash
cd /home/runner/work/sm2/sm2
export PATH="/tmp/flutter/bin:$PATH"
flutter analyze && flutter test
```

### Build and Test Example App  
```bash
cd /home/runner/work/sm2/sm2/example
export PATH="/tmp/flutter/bin:$PATH"
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### Full Validation Pipeline
```bash
cd /home/runner/work/sm2/sm2
export PATH="/tmp/flutter/bin:$PATH"

# Main package
flutter pub get
flutter analyze
flutter test
flutter pub publish --dry-run

# Example app
cd example
flutter pub get  
flutter build web
```

Remember: **ALWAYS run flutter analyze and flutter test** before committing changes. The algorithm correctness is critical for spaced repetition functionality.

## Common Files Reference

The following are outputs from frequently accessed files. Reference them instead of viewing, searching, or running bash commands to save time.

### Repository Root Structure
```
ls -la /home/runner/work/sm2/sm2
.git
.gitignore
.metadata
CHANGELOG.md
LICENSE
README.md
example/
lib/
pubspec.lock
pubspec.yaml
test/
```

### Core Algorithm Implementation (lib/sm.dart)
```dart
/// Class providing calc function
class Sm {
  SmResponse calc({
    required int quality,        // 0-5 rating of recall difficulty
    required int repetitions,    // Number of previous reviews
    required int previousInterval, // Days since last review
    required double previousEaseFactor, // Ease factor from previous calc
  }) {
    // Returns SmResponse with: interval, repetitions, easeFactor
  }
}
```

### Package Configuration (pubspec.yaml - key sections)
```yaml
name: spaced_repetition
description: Simple implementation of the sm2 spaced repetition algorithm
version: 0.1.0
environment:
  sdk: ">=2.12.0 <3.0.0"
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
```