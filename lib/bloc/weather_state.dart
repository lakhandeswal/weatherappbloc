import 'package:equatable/equatable.dart';
import 'package:teconicobloc/Models/WeatherData.dart';

class WeatherState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotSearchingState extends WeatherState {}

class SearchingState extends WeatherState {}

class SearchedState extends WeatherState {
  final WeatherData weatherData;

  SearchedState(this.weatherData);

  @override
  // TODO: implement props
  List<Object> get props => [weatherData];
}
