
class CitySearchModel {
  final List<Result>? results;
  final double? generationtimeMs;
  


  CitySearchModel({
    this.results,
    this.generationtimeMs,
  });

  factory CitySearchModel.fromJson(Map<String, dynamic> json) {
    return CitySearchModel(
      results: json["results"] == null
          ? []
          : List<Result>.from(
        json["results"].map((x) => Result.fromJson(x)),
      ),
      generationtimeMs: json["generationtime_ms"]?.toDouble(),
    );
  }

}

class Result {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? country;
  final String? admin1;
  final String? admin2;
  final String? timezone;

  Result({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.country,
    this.admin1,
    this.admin2,
    this.timezone,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json["id"],
      name: json["name"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      country: json["country"],
      admin1: json["admin1"],
      admin2: json["admin2"],
      timezone: json["timezone"],
    );
  }
}


