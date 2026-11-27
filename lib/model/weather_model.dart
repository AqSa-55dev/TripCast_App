
import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) =>
    json.encode(data.toJson());

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
  final DailyUnits? dailyUnits;
  final Daily? daily;

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
    this.dailyUnits,
    this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      WeatherModel(
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
        current: json["current"] == null
            ? null
            : Current.fromJson(json["current"]),
        hourlyUnits: json["hourly_units"] == null
            ? null
            : HourlyUnits.fromJson(json["hourly_units"]),
        hourly: json["hourly"] == null
            ? null
            : Hourly.fromJson(json["hourly"]),
        dailyUnits: json["daily_units"] == null
            ? null
            : DailyUnits.fromJson(json["daily_units"]),
        daily: json["daily"] == null
            ? null
            : Daily.fromJson(json["daily"]),
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
    "daily_units": dailyUnits?.toJson(),
    "daily": daily?.toJson(),
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

  factory CurrentUnits.fromJson(Map<String, dynamic> json) =>
      CurrentUnits(
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
  final List<double>? apparentTemperature;
  final List<int>? relativeHumidity2M;
  final List<int>? precipitationProbability;
  final List<int>? weatherCode;
  final List<double>? windSpeed10M;
  final List<double>? uvIndex;
  final List<double>? visibility;

  Hourly({
    this.time,
    this.temperature2M,
    this.apparentTemperature,
    this.relativeHumidity2M,
    this.precipitationProbability,
    this.weatherCode,
    this.windSpeed10M,
    this.uvIndex,
    this.visibility,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: json["time"] == null
        ? []
        : List<String>.from(json["time"]),
    temperature2M: _doubleList(json["temperature_2m"]),
    apparentTemperature: _doubleList(json["apparent_temperature"]),
    relativeHumidity2M: _intList(json["relative_humidity_2m"]),
    precipitationProbability:
    _intList(json["precipitation_probability"]),
    weatherCode: _intList(json["weather_code"]),
    windSpeed10M: _doubleList(json["wind_speed_10m"]),
    uvIndex: _doubleList(json["uv_index"]),
    visibility: _doubleList(json["visibility"]),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "apparent_temperature": apparentTemperature,
    "relative_humidity_2m": relativeHumidity2M,
    "precipitation_probability": precipitationProbability,
    "weather_code": weatherCode,
    "wind_speed_10m": windSpeed10M,
    "uv_index": uvIndex,
    "visibility": visibility,
  };
}

class HourlyUnits {
  final String? time;
  final String? temperature2M;
  final String? apparentTemperature;
  final String? relativeHumidity2M;
  final String? precipitationProbability;
  final String? weatherCode;
  final String? windSpeed10M;
  final String? uvIndex;
  final String? visibility;

  HourlyUnits({
    this.time,
    this.temperature2M,
    this.apparentTemperature,
    this.relativeHumidity2M,
    this.precipitationProbability,
    this.weatherCode,
    this.windSpeed10M,
    this.uvIndex,
    this.visibility,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) =>
      HourlyUnits(
        time: json["time"],
        temperature2M: json["temperature_2m"],
        apparentTemperature: json["apparent_temperature"],
        relativeHumidity2M: json["relative_humidity_2m"],
        precipitationProbability: json["precipitation_probability"],
        weatherCode: json["weather_code"],
        windSpeed10M: json["wind_speed_10m"],
        uvIndex: json["uv_index"],
        visibility: json["visibility"],
      );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "apparent_temperature": apparentTemperature,
    "relative_humidity_2m": relativeHumidity2M,
    "precipitation_probability": precipitationProbability,
    "weather_code": weatherCode,
    "wind_speed_10m": windSpeed10M,
    "uv_index": uvIndex,
    "visibility": visibility,
  };
}

class Daily {
  final List<String>? time;
  final List<double>? temperature2MMax;
  final List<double>? temperature2MMin;
  final List<String>? sunrise;
  final List<String>? sunset;
  final List<double>? uvIndexMax;

  Daily({
    this.time,
    this.temperature2MMax,
    this.temperature2MMin,
    this.sunrise,
    this.sunset,
    this.uvIndexMax,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
    time: json["time"] == null
        ? []
        : List<String>.from(json["time"]),
    temperature2MMax: _doubleList(json["temperature_2m_max"]),
    temperature2MMin: _doubleList(json["temperature_2m_min"]),
    sunrise: json["sunrise"] == null
        ? []
        : List<String>.from(json["sunrise"]),
    sunset: json["sunset"] == null
        ? []
        : List<String>.from(json["sunset"]),
    uvIndexMax: _doubleList(json["uv_index_max"]),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m_max": temperature2MMax,
    "temperature_2m_min": temperature2MMin,
    "sunrise": sunrise,
    "sunset": sunset,
    "uv_index_max": uvIndexMax,
  };
}

class DailyUnits {
  final String? time;
  final String? temperature2MMax;
  final String? temperature2MMin;
  final String? sunrise;
  final String? sunset;
  final String? uvIndexMax;

  DailyUnits({
    this.time,
    this.temperature2MMax,
    this.temperature2MMin,
    this.sunrise,
    this.sunset,
    this.uvIndexMax,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) =>
      DailyUnits(
        time: json["time"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        uvIndexMax: json["uv_index_max"],
      );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m_max": temperature2MMax,
    "temperature_2m_min": temperature2MMin,
    "sunrise": sunrise,
    "sunset": sunset,
    "uv_index_max": uvIndexMax,
  };
}

// Helper methods for safely reading API lists
List<double> _doubleList(dynamic value) {
  if (value == null) return [];

  return List<double>.from(
    value.map((item) => item == null ? 0.0 : item.toDouble()),
  );
}

List<int> _intList(dynamic value) {
  if (value == null) return [];

  return List<int>.from(
    value.map((item) => item == null ? 0 : item as int),
  );
}
