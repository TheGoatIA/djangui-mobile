// Pilote des mesures de performance (mode PROFILE) :
//   flutter drive --profile --driver=test_driver/perf_driver.dart \
//     --target=integration_test/perf/perf_test.dart -d <appareil> \
//     --dart-define=API_BASE_URL=http://10.0.2.2:5055/api/v1
// Écrit build/<scénario>.timeline_summary.json (temps de build/raster des
// images, 90e/99e centiles, images manquées) pour chaque scénario mesuré.
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    for (final entry in data.entries) {
      // Ignore les entrées qui ne sont pas des timelines (ex. failureDetails).
      final v = entry.value;
      if (v is! Map<String, dynamic> || !v.containsKey('traceEvents')) continue;
      final timeline = driver.Timeline.fromJson(v);
      final summary = driver.TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(
        entry.key,
        pretty: true,
        includeSummary: true,
      );
    }
  },
);
