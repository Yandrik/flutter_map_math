library flutter_map_math;

import 'dart:math';

import 'package:latlong2/latlong.dart';

/// Map related calculations class
class FlutterMapMath {
  /// converts kilometers to desired(meters, miles, yards) units
  double toRequestedUnit(String unit, double distanceInKm) {
    switch (unit) {
      case 'kilometers':
        return distanceInKm;
      case 'meters':
        return distanceInKm * 1000;
      case 'miles':
        return (distanceInKm * 1000) / 1609.344;
      case 'yards':
        return distanceInKm * 1093.61;
      case '':
        return distanceInKm;
    }
    return distanceInKm;
  }

  // Constants defined by the WGS-84 ellipsoid model
  final double a = 6378137.0; // Semi-major axis
  final double b = 6356752.314245; // Semi-minor axis
  final double f = 1 / 298.257223563; // Flattening


  /// Returns distance between two locations on earth
double distanceBetween(double lat1, double lon1, double lat2, double lon2, String unit) {
  // Convert latitude and longitude from degrees to radians
  double U1 = atan((1 - f) * tan(degreesToRadians(lat1)));
  double U2 = atan((1 - f) * tan(degreesToRadians(lat2)));
  double L = degreesToRadians(lon2 - lon1);
  double lambda = L;
  double lambdaP;
  int iterLimit = 100;

  double sinSigma, cosSigma, sigma, sinAlpha, cosSqAlpha, cos2SigmaM, C;
  do {
    double sinLambda = sin(lambda);
    double cosLambda = cos(lambda);
    sinSigma = sqrt((pow(cos(U2) * sinLambda, 2)) +
                    (pow(cos(U1) * sin(U2) - sin(U1) * cos(U2) * cosLambda, 2)));
    if (sinSigma == 0) {
      return 0;  // co-incident points
    }
    cosSigma = sin(U1) * sin(U2) + cos(U1) * cos(U2) * cosLambda;
    sigma = atan2(sinSigma, cosSigma);
    sinAlpha = cos(U1) * cos(U2) * sinLambda / sinSigma;
    cosSqAlpha = 1 - pow(sinAlpha, 2) as double;
    cos2SigmaM = cosSigma - 2 * sin(U1) * sin(U2) / cosSqAlpha;
    if (cos2SigmaM.isNaN) {
      cos2SigmaM = 0;  // equatorial line
    }
    C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    lambdaP = lambda;
    lambda = L + (1 - C) * f * sinAlpha *
             (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
  } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

  if (iterLimit == 0) {
    return double.nan;  // formula failed to converge
  }

  double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
  double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
  double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                      B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));

  double s = b * A * (sigma - deltaSigma) / 1000;

  return toRequestedUnit(unit, s);
}

  /// Returns bearing angle in degrees.
  /// Bearing angle => A bearing describes a line as heading north or south, and
  /// deflected some number of degrees toward the east or west. A bearing,
  /// therefore, will always have an angle less than 90°.
  double bearingBetween(double lat1, double lon1, double lat2, double lon2) {
    var dLon = degreesToRadians(lon2 - lon1);
    var y = sin(dLon) * cos(degreesToRadians(lat2));
    var x = cos(degreesToRadians(lat1)) * sin(degreesToRadians(lat2)) -
        sin(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) * cos(dLon);
    var angle = atan2(y, x);
    return (radiansToDegrees(angle) + 360) % 360;
  }

  /// Uses a point, distance and bearing anlge to find the destination point.
  /// Returns LatLng Object
  LatLng destinationPoint(
      double lat, double lng, double distance, double bearing) {
    double radius = 6371 * 1000; // Earth's radius in meters
    double distRatio = distance / radius;
    double bearingRadians = degreesToRadians(bearing);
    double startLatRadians = degreesToRadians(lat);
    double startLngRadians = degreesToRadians(lng);

    double endLatRadians = asin(sin(startLatRadians) * cos(distRatio) +
        cos(startLatRadians) * sin(distRatio) * cos(bearingRadians));

    double endLngRadians = startLngRadians +
        atan2(sin(bearingRadians) * sin(distRatio) * cos(startLatRadians),
            cos(distRatio) - sin(startLatRadians) * sin(endLatRadians));

    double endLat = radiansToDegrees(endLatRadians);
    double endLng = radiansToDegrees(endLngRadians);

    return LatLng(endLat, endLng);
  }

  /// Returns the mid point of two locations on earth.
  /// Returns a LatLng object(the coordinates of mid point)

  LatLng midpointBetween(LatLng location1, LatLng location2) {
    // double dLat = degreesToRadians(lat2 - lat1);
    double dLng = degreesToRadians(location2.longitude - location1.longitude);
    double lat1Radians = degreesToRadians(location1.latitude);
    double lat2Radians = degreesToRadians(location2.latitude);

    double bX = cos(lat2Radians) * cos(dLng);
    double bY = cos(lat2Radians) * sin(dLng);
    double midLatRadians = atan2(sin(lat1Radians) + sin(lat2Radians),
        sqrt((cos(lat1Radians) + bX) * (cos(lat1Radians) + bX) + bY * bY));
    double midLngRadians = degreesToRadians(location1.longitude) +
        atan2(bY, cos(lat1Radians) + bX);

    double midLat = radiansToDegrees(midLatRadians);
    double midLng = radiansToDegrees(midLngRadians);

    return LatLng(midLat, midLng);
  }

  /// A function to calculate the intersection of two lines on Earth
  /// Returns a LatLng object with the latitude and longitude of the intersection point
  LatLng calculateIntersection(
      LatLng location1, double bearing1, LatLng location2, double bearing2) {
    // Convert degrees to radians
    double lat1Rad = degreesToRadians(location1.latitude);
    double lon1Rad = degreesToRadians(location1.longitude);
    double bearing1Rad = degreesToRadians(bearing1);
    double lat2Rad = degreesToRadians(location2.latitude);
    double lon2Rad = degreesToRadians(location2.longitude);
    // double bearing2Rad = degreesToRadians(bearing2);

    // Calculate the intersection point
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double dist12 = 2 *
        asin(sqrt(pow(sin(dLat / 2), 2) +
            cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2)));
    if (dist12 == 0) {
      throw Exception("Lines are parallel, intersection is undefined.");
    }

    double bearingA = acos((sin(lat2Rad) - sin(lat1Rad) * cos(dist12)) /
        (sin(dist12) * cos(lat1Rad)));
    // double bearingB = acos((sin(lat1Rad) - sin(lat2Rad) * cos(dist12)) /
    // (sin(dist12) * cos(lat2Rad)));

    double intersectionLat = asin(sin(lat1Rad) * cos(bearingA) +
        cos(lat1Rad) * sin(bearingA) * cos(bearing1Rad));
    double intersectionLon = lon1Rad +
        atan2(sin(bearing1Rad) * sin(bearingA) * cos(lat1Rad),
            cos(bearingA) - sin(lat1Rad) * sin(intersectionLat));

    // Convert back to degrees
    double intersectionLatDeg = radiansToDegrees(intersectionLat);
    double intersectionLonDeg = radiansToDegrees(intersectionLon);

    return LatLng(intersectionLatDeg, intersectionLonDeg);
  }

  /// function for proximity detection that takes in the user's current location
  /// and a list of points representing areas on the map, and returns a list of
  /// points that are within a certain distance of the user's location
  List<LatLng> detectProximity(
      LatLng userLocation, List<LatLng> mapPoints, double distanceThreshold) {
    List<LatLng> nearbyPoints = [];

    for (LatLng point in mapPoints) {
      double distance = sqrt(pow(userLocation.latitude - point.latitude, 2) +
          pow(userLocation.longitude - point.longitude, 2));
      if (distance <= distanceThreshold) {
        nearbyPoints.add(point);
      }
    }

    return nearbyPoints;
  }

  // function that takes a center location and a radius in meters
  // and returns a function that takes a location and returns a boolean
  // indicating whether the location is within the boundary.
  Function createBoundary(LatLng center, double radius) {
    checkBoundary(LatLng location) {
      double distanceInMeters = distanceBetween(
        center.latitude,
        center.longitude,
        location.latitude,
        location.longitude,
        'meters',
      );
      return distanceInMeters <= radius;
    }

    return checkBoundary;
  }

  double calculateArea(List<Map<String, double?>> vertices) {
    int numPoints = vertices.length;
    double area = 0;

    if (numPoints > 2) {
      for (int i = 0; i < numPoints; i++) {
        Map<String, double?> point1 = vertices[i];
        Map<String, double?> point2 = vertices[(i + 1) % numPoints];
        area += (point1['longitude'] ?? 0.0) * (point2['latitude'] ?? 0.0) -
            (point1['latitude'] ?? 0.0) * (point2['longitude'] ?? 0.0);
      }
      area /= 2;
    }

    return area.abs();
  }

  /// Convert degrees to radians
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// converts radians to degrees
  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }
}
