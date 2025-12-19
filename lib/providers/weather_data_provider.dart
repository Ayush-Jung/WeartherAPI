import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/networks/weather_api.dart';

class WeatherDataProvider extends ChangeNotifier {
  late DateTime selectedDay, focusDay;
  List<WeatherModel>? weeklyWeatherInfo;
  WeatherModel? selectedDateWeatherInfo;
  bool isLoading = false;

  WeatherDataProvider() {
    // Here for now we can initialize both selected Day and focus Day.
    selectedDay = DateTime.now();
    focusDay = selectedDay;
    // Fetching weekly data at once in the beggining cause its a first screen
    setIsLoading(true);
    fetchWeeklyWeatherInfo();
    notifyListeners();
  }

  setIsLoading(bool data) {
    isLoading = data;
    notifyListeners();
  }

  handleOnSelectData(DateTime day) {
    focusDay = day;
    selectedDay = day;
    log('Selected Date ${selectedDay.toString()}');
    fetchSelectedDateWeatherData();
    notifyListeners();
  }

  fetchWeeklyWeatherInfo() async {
    try {
      weeklyWeatherInfo ??= await WeatherApi().fetchCurrentDateWeather();
    } on Exception catch (e) {
      weeklyWeatherInfo = [];
      setIsLoading(false);
      throw e.toString();
    }
    // initialize first data
    fetchSelectedDateWeatherData();
    setIsLoading(false);
    notifyListeners();
  }

  fetchSelectedDateWeatherData() {
    try {
      selectedDateWeatherInfo =
          WeatherApi().getWeatherByDate(weeklyWeatherInfo!, selectedDay);
      notifyListeners();
      log(selectedDateWeatherInfo!.tempMax.toString());
      log(selectedDateWeatherInfo!.date.toString());
    } catch (e) {
      setIsLoading(false);
      throw Exception('No Weather Data Found');
    }
  }

  String getWeatherConditionByCode(int code) {
    if (code == 0) return WeaterCondition.sunny.name;
    if (code >= 1 && code <= 3) return WeaterCondition.clody.name;
    if (code > 3 && code < 51) return WeaterCondition.sunny.name;
    if ((code >= 51 && code <= 82) || code == 61 || code == 63 || code == 65) {
      return WeaterCondition.rainny.name;
    }
    if ((code >= 71 && code <= 75)) return WeaterCondition.snowy.name;
    if (code == 95) return WeaterCondition.thunderstorm.name;
    return WeaterCondition.unknown.name;
  }
}
