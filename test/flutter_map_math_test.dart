import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:flutter_test/flutter_test.dart';

/// TESTS
void main() {
  test('find distance between', () {
    final calculator = FlutterMapMath();
    print(calculator.distanceBetween(
        37.4219999, -122.0840575, 37.4220011, -122.0866519, "meters"));
    print(calculator.bearingBetween(
        37.4219999, -122.0840575, 37.4220011, -122.0866519));
  });

test('bearing between', () {
    final calculator = FlutterMapMath();

    // Bearing from San Francisco (37.7749, -122.4194) to Los Angeles (34.0522, -118.2437)
    expect(calculator.bearingBetween(37.7749, -122.4194, 34.0522, -118.2437), closeTo(136.50, 0.01));
    
    // Bearing from New York (40.7128, -74.0060) to Washington DC (38.9072, -77.0369)
    expect(calculator.bearingBetween(40.7128, -74.0060, 38.9072, -77.0369), closeTo(233.18, 0.01));
    
    // Bearing from London (51.5074, -0.1278) to Paris (48.8566, 2.3522)
    expect(calculator.bearingBetween(51.5074, -0.1278, 48.8566, 2.3522), closeTo(148.12, 0.01));
    
    // Bearing from Sydney (-33.8688, 151.2093) to Melbourne (-37.8136, 144.9631)
    expect(calculator.bearingBetween(-33.8688, 151.2093, -37.8136, 144.9631), closeTo(230.28, 0.01));
    
    // Bearing from Tokyo (35.6895, 139.6917) to Osaka (34.6937, 135.5023)
    expect(calculator.bearingBetween(35.6895, 139.6917, 34.6937, 135.5023), closeTo(255.00, 0.01));
  });

test('find distance between', () {
    final calculator = FlutterMapMath();

    // note: distances are calculated using more accurate model, so they're slightly off here (WGS-84 model). That's why
    //       the closeTo values always have fairly high tolerance bands
    
    // Distance from San Francisco to Los Angeles
    expect(calculator.distanceBetween(37.7749, -122.4194, 34.0522, -118.2437, "meters"), closeTo(559042.34, 1.0));
    expect(calculator.distanceBetween(37.7749, -122.4194, 34.0522, -118.2437, "kilometers"), closeTo(559.04, 0.01));
    expect(calculator.distanceBetween(37.7749, -122.4194, 34.0522, -118.2437, "miles"), closeTo(347.37, 0.01));
    expect(calculator.distanceBetween(37.7749, -122.4194, 34.0522, -118.2437, "yards"), closeTo(611374.29, 1.0));

    // Distance from New York to Washington DC
    expect(calculator.distanceBetween(40.7128, -74.0060, 38.9072, -77.0369, "meters"), closeTo(327912.52, 1.0));
    expect(calculator.distanceBetween(40.7128, -74.0060, 38.9072, -77.0369, "kilometers"), closeTo(327.91, 0.01));
    expect(calculator.distanceBetween(40.7128, -74.0060, 38.9072, -77.0369, "miles"), closeTo(203.76, 0.01));
    expect(calculator.distanceBetween(40.7128, -74.0060, 38.9072, -77.0369, "yards"), closeTo(358608.41, 1.0));
    
    // Distance from London to Paris
    expect(calculator.distanceBetween(51.5074, -0.1278, 48.8566, 2.3522, "meters"), closeTo(343923.12, 1.0));
    expect(calculator.distanceBetween(51.5074, -0.1278, 48.8566, 2.3522, "kilometers"), closeTo(343.92, 0.01));
    expect(calculator.distanceBetween(51.5074, -0.1278, 48.8566, 2.3522, "miles"), closeTo(213.70, 0.01));
    expect(calculator.distanceBetween(51.5074, -0.1278, 48.8566, 2.3522, "yards"), closeTo(376117.76, 1.0));

    // Distance from Sydney to Melbourne
    expect(calculator.distanceBetween(-33.8688, 151.2093, -37.8136, 144.9631, "meters"), closeTo(713857.67, 1.0));
    expect(calculator.distanceBetween(-33.8688, 151.2093, -37.8136, 144.9631, "kilometers"), closeTo(713.86, 0.01));
    expect(calculator.distanceBetween(-33.8688, 151.2093, -37.8136, 144.9631, "miles"), closeTo(443.57, 0.01));
    expect(calculator.distanceBetween(-33.8688, 151.2093, -37.8136, 144.9631, "yards"), closeTo(780681.88, 1.0));

    // Distance from Tokyo to Osaka
    expect(calculator.distanceBetween(35.6895, 139.6917, 34.6937, 135.5023, "meters"), closeTo(397183.09, 1.0));
    expect(calculator.distanceBetween(35.6895, 139.6917, 34.6937, 135.5023, "kilometers"), closeTo(397.18, 0.01));
    expect(calculator.distanceBetween(35.6895, 139.6917, 34.6937, 135.5023, "miles"), closeTo(246.80, 0.01));
    expect(calculator.distanceBetween(35.6895, 139.6917, 34.6937, 135.5023, "yards"), closeTo(434363.39, 1.0));
});



}
