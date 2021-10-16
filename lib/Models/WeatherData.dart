import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final num temperature;

  WeatherData({required this.temperature});

  @override
  // TODO: implement props
  List<Object> get props => [temperature];

  num get temp => temperature;

  factory WeatherData.fromJson(dynamic json) {
    return WeatherData(
      temperature: json['temp'] as double,
    );
  }
}
