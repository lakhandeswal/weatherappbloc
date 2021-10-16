import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final num temperature;

  WeatherData({required this.temperature});

  @override
  // TODO: implement props
  List<Object> get props => [temperature];

  num get temp => temperature;

  factory WeatherData.fromJson(dynamic json) {
    final consolidatedWeather = json['consolidated_weather'][0];
    return WeatherData(
      temperature: consolidatedWeather[0]['the_temp'] as double,
    );
  }
}
