import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final int? elevation;
  final CurrentUnits? currentUnits;
  final Current? current;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;

  WeatherModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentUnits,
    this.current,
    this.hourlyUnits,
    this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    currentUnits: json["current_units"] == null
        ? null
        : CurrentUnits.fromJson(json["current_units"]),
    current:
    json["current"] == null ? null : Current.fromJson(json["current"]),
    hourlyUnits: json["hourly_units"] == null
        ? null
        : HourlyUnits.fromJson(json["hourly_units"]),
    hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "current_units": currentUnits?.toJson(),
    "current": current?.toJson(),
    "hourly_units": hourlyUnits?.toJson(),
    "hourly": hourly?.toJson(),
  };
}

class Current {
  final String? time;
  final int? interval;
  final double? temperature2M;
  final int? relativeHumidity2M;
  final int? weatherCode;
  final double? windSpeed10M;

  Current({
    this.time,
    this.interval,
    this.temperature2M,
    this.relativeHumidity2M,
    this.weatherCode,
    this.windSpeed10M,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    time: json["time"],
    interval: json["interval"],
    temperature2M: json["temperature_2m"]?.toDouble(),
    relativeHumidity2M: json["relative_humidity_2m"],
    weatherCode: json["weather_code"],
    windSpeed10M: json["wind_speed_10m"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature_2m": temperature2M,
    "relative_humidity_2m": relativeHumidity2M,
    "weather_code": weatherCode,
    "wind_speed_10m": windSpeed10M,
  };
}

class CurrentUnits {
  final String? time;
  final String? interval;
  final String? temperature2M;
  final String? relativeHumidity2M;
  final String? weatherCode;
  final String? windSpeed10M;

  CurrentUnits({
    this.time,
    this.interval,
    this.temperature2M,
    this.relativeHumidity2M,
    this.weatherCode,
    this.windSpeed10M,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
    time: json["time"],
    interval: json["interval"],
    temperature2M: json["temperature_2m"],
    relativeHumidity2M: json["relative_humidity_2m"],
    weatherCode: json["weather_code"],
    windSpeed10M: json["wind_speed_10m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature_2m": temperature2M,
    "relative_humidity_2m": relativeHumidity2M,
    "weather_code": weatherCode,
    "wind_speed_10m": windSpeed10M,
  };
}

class Hourly {
  final List<String>? time;
  final List<double>? temperature2M;
  final List<int>? precipitationProbability;
  final List<int>? weatherCode;

  Hourly({
    this.time,
    this.temperature2M,
    this.precipitationProbability,
    this.weatherCode,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: json["time"] == null
        ? []
        : List<String>.from(json["time"]!.map((x) => x)),
    temperature2M: json["temperature_2m"] == null
        ? []
        : List<double>.from(
        json["temperature_2m"]!.map((x) => x?.toDouble())),
    precipitationProbability: json["precipitation_probability"] == null
        ? []
        : List<int>.from(
        json["precipitation_probability"]!.map((x) => x)),
    weatherCode: json["weather_code"] == null
        ? []
        : List<int>.from(json["weather_code"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "temperature_2m": temperature2M == null
        ? []
        : List<dynamic>.from(temperature2M!.map((x) => x)),
    "precipitation_probability": precipitationProbability == null
        ? []
        : List<dynamic>.from(precipitationProbability!.map((x) => x)),
    "weather_code": weatherCode == null
        ? []
        : List<dynamic>.from(weatherCode!.map((x) => x)),
  };
}

class HourlyUnits {
  final String? time;
  final String? temperature2M;
  final String? precipitationProbability;
  final String? weatherCode;

  HourlyUnits({
    this.time,
    this.temperature2M,
    this.precipitationProbability,
    this.weatherCode,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],
    precipitationProbability: json["precipitation_probability"],
    weatherCode: json["weather_code"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "precipitation_probability": precipitationProbability,
    "weather_code": weatherCode,
  };
}