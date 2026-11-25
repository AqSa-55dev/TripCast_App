class JourneyModel {
  final String? id;

  final String startLocation;
  final double startLatitude;
  final double startLongitude;

  final String destination;
  final double destinationLatitude;
  final double destinationLongitude;

  final DateTime departureDateTime;

  final String? distance;
  final String? duration;

  final List<List<double>>? routeCoordinates;

  JourneyModel({
    this.id,
    required this.startLocation,
    required this.startLatitude,
    required this.startLongitude,
    required this.destination,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.departureDateTime,
    this.distance,
    this.duration,
    this.routeCoordinates,
  });
}