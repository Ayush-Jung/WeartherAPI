class WeatherModel {
  double tempMax, tempMin;
  int weatherCode;
  String date;
  WeatherModel({
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        tempMax: json['max'],
        date: json['date'],
        tempMin: json['min'],
        weatherCode: json['code']);
  }
}

WeaterCondition getWeatherConditionInEnum(String data) {
  return WeaterCondition.values.firstWhere((e) => e.name == data);
}

enum WeaterCondition { sunny, clody, rainny, snowy, thunderstorm, unknown }
