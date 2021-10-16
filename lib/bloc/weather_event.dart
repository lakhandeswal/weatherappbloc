import 'package:equatable/equatable.dart';

class WeatherEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetWeatherData extends WeatherEvent {
  final String cityName;

  GetWeatherData({required this.cityName});

  @override
  // TODO: implement props
  List<Object> get props => [cityName];
}

class ResetWeatherData extends WeatherEvent {}
