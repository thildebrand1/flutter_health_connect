import 'package:flutter_health_connect/src/units/length.dart';

class ExerciseRoute {
  List<Location> route;

  ExerciseRoute({
    required this.route,
  }) {
    List<Location> sortedRoute = route
      ..sort((a, b) => a.time.compareTo(b.time));
    for (int i = 0; i < sortedRoute.length - 1; i++) {
      assert(sortedRoute[i].time.isBefore(sortedRoute[i + 1].time));
    }
  }

  bool isWithin(DateTime startTime, DateTime endTime) {
    // startTime is inclusive, endTime is exclusive
    final sortedRoute = route..sort((a, b) => a.time.compareTo(b.time));
    return !sortedRoute.first.time.isBefore(startTime) &&
        sortedRoute.last.time.isBefore(endTime);
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is ExerciseRoute && route == other.route;
  }

  @override
  int get hashCode => route.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'route': route.map((x) => x.toMap()).toList(),
    };
  }

  factory ExerciseRoute.fromMap(Map<String, dynamic> map) {
    return ExerciseRoute(
      route: List<Location>.from(map['route']?.map((x) => Location.fromMap(x))),
    );
  }

  @override
  String toString() => 'ExerciseRoute(route: $route)';
}

class Location {
  DateTime time;
  double latitude;
  double longitude;
  Length? altitude;
  Length? horizontalAccuracy;
  Length? verticalAccuracy;

  Location({
    required this.time,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.horizontalAccuracy,
    this.verticalAccuracy,
  })  : assert(latitude >= _minLatitude && latitude <= _maxLatitude),
        assert(longitude >= _minLongitude && longitude <= _maxLongitude),
        assert(horizontalAccuracy == null ||
            (horizontalAccuracy.inMeters >= _minHorizontalAccuracy.inMeters)),
        assert(verticalAccuracy == null ||
            (verticalAccuracy.inMeters >= _minVerticalAccuracy.inMeters));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          time == other.time &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          altitude == other.altitude &&
          horizontalAccuracy == other.horizontalAccuracy &&
          verticalAccuracy == other.verticalAccuracy;

  @override
  int get hashCode =>
      time.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      altitude.hashCode ^
      horizontalAccuracy.hashCode ^
      verticalAccuracy.hashCode;

  static const double _minLatitude = -90.0;
  static const double _maxLatitude = 90.0;
  static const double _minLongitude = -180.0;
  static const double _maxLongitude = 180.0;
  static const Length _minHorizontalAccuracy = Length.meters(0);
  static const Length _minVerticalAccuracy = Length.meters(0);

  Map<String, dynamic> toMap() {
    return {
      'time': time.toUtc().toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude?.inMeters,
      'horizontalAccuracy': horizontalAccuracy?.inMeters,
      'verticalAccuracy': verticalAccuracy?.inMeters,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      time: DateTime.parse(map['time']),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      altitude: map['altitude'] != null
          ? Length.fromMap(Map<String, dynamic>.from(map['altitude']))
          : null,
      horizontalAccuracy: map['horizontalAccuracy'] != null
          ? Length.fromMap(Map<String, dynamic>.from(map['horizontalAccuracy']))
          : null,
      verticalAccuracy: map['verticalAccuracy'] != null
          ? Length.fromMap(Map<String, dynamic>.from(map['verticalAccuracy']))
          : null,
    );
  }

  @override
  String toString() {
    return 'Location(time: $time, latitude: $latitude, longitude: $longitude, altitude: $altitude, horizontalAccuracy: $horizontalAccuracy, verticalAccuracy: $verticalAccuracy)';
  }
}
