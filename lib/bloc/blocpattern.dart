import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:teconicobloc/bloc/weather_event.dart';
import 'package:teconicobloc/bloc/weather_state.dart';
import '../Models/WeatherData.dart';

class BlocPattern extends Bloc<WeatherEvent, WeatherState> {
  BlocPattern(WeatherState initialState) : super(initialState);
  final _stateController = StreamController<WeatherData>();
  StreamSink<WeatherData> get stateSink => _stateController.sink;
  Stream<WeatherData> get stateStream => _stateController.stream;

  @override
  // ignore: override_on_non_overriding_member
  WeatherState get initialState => NotSearchingState();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is GetWeatherData) {
      print('Weather searching');
      yield SearchingState();
      try {
        final weather = await _fetchWeatherData(event.cityName);
        print(weather);
        yield SearchedState(weather);
      } catch (exception) {
        print(exception);
      }
    } else if (event is ResetWeatherData) {
      print('Weather reset');
      yield NotSearchingState();
    }
  }

  Future<WeatherData> _fetchWeatherData(String cityName) async {
    //use api
    final result = await http.Client().get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=2fb9a05b8ad052cb8ef1250f68276e1e'));
    if (result.statusCode != 200) {
      throw Exception();
    } else {
      print(result.body);
      return parsedJson(result.body);
    }
  }

  WeatherData parsedJson(final response) {
    final responseData = json.decode(response);
    final weatherData = responseData["main"];
    print('WeatherData: ${weatherData["temp"]}');
    _stateController.sink.add(WeatherData.fromJson(weatherData));
    return WeatherData.fromJson(weatherData);
  }

  @override
  void dispose() {
    _stateController.close();
  }
}
