import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherApi {
  final Dio _dio = Dio();

// To minimize API call we will fetch wellky weather data at once.
  Future<List<WeatherModel>> fetchCurrentDateWeather() async {
    const url =
        'https://api.open-meteo.com/v1/forecast?latitude=27.7172&longitude=85.3240&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto';

    try {
      final response = await _dio.get(url);
      final daily = response.data['daily'];

      return List.generate(daily['time'].length, (i) {
        return WeatherModel(
            tempMax: daily['temperature_2m_max'][i],
            tempMin: daily['temperature_2m_min'][i],
            weatherCode: daily['weathercode'][i],
            date: DateTime.parse(daily['time'][i]).toString().split(" ")[0]);
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(' API Connection issues');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(' Network Connection issues');
      } else {
        throw Exception('Failed to fetch weather: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

// RThis will send weather data based on selected date.
  WeatherModel getWeatherByDate(
      List<WeatherModel> weather, DateTime selectedDate) {
    String _sDate = selectedDate.toString().split(" ")[0];
    // [log] {date: 2025-12-21 00:00:00.000, max: 21.4, min: 10.2, code: 45}
    return weather.firstWhere((day) => day.date == _sDate);
  }
}
