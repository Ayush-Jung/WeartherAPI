import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherDataProvider =
        Provider.of<WeatherDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather API'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          spacing: 30,
          children: [
            TableCalendar(
              focusedDay: weatherDataProvider.focusDay,
              currentDay: weatherDataProvider.selectedDay,
              firstDay: DateTime(2025),
              lastDay: DateTime(2027),
              onDaySelected: (selectedDay, focusedDay) {
                try {
                  weatherDataProvider.handleOnSelectData(selectedDay);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Error!! Please only select upto 7 days from Today')));
                }
              },
            ),
            if (weatherDataProvider.isLoading)
              CircularProgressIndicator()
            else if (weatherDataProvider.weeklyWeatherInfo != null &&
                weatherDataProvider.weeklyWeatherInfo!.isEmpty)
              Center(
                child: Text('No Weather Data found from API'),
              )
            else if (weatherDataProvider.selectedDateWeatherInfo != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                        weatherDataProvider.selectedDateWeatherInfo!.date
                            .toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      title: Text(
                        'Maximun Temp: ${weatherDataProvider.selectedDateWeatherInfo!.tempMax.toString()}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        'Minmum Temp: ${weatherDataProvider.selectedDateWeatherInfo!.tempMin.toString()}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      trailing: Text(
                        weatherDataProvider.getWeatherConditionByCode(
                            weatherDataProvider
                                .selectedDateWeatherInfo!.weatherCode),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
