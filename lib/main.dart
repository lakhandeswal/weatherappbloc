import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:teconicobloc/bloc/weather_event.dart';
import 'package:teconicobloc/bloc/weather_state.dart';
import 'Models/WeatherData.dart';
import 'bloc/blocpattern.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocProvider(
          create: (context) => BlocPattern(NotSearchingState()),
          child: MainScreen(),
        ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController controller = TextEditingController();
  final weatherBloc = BlocPattern(NotSearchingState());
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<BlocPattern>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Bloc Pattern'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: BlocBuilder(
              bloc: weatherBloc,
              builder: (context, state) {
                if (state is NotSearchingState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Search City",
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                )),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          MaterialButton(
                            onPressed: () {
                              weatherBloc.add(
                                  GetWeatherData(cityName: controller.text));
                            },
                            color: Colors.blue,
                            child: Text("Search"),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (state is SearchingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchedState) {
                  return ShowData(state.weatherData, controller.text);
                }
                return Text('Nothing to show');
              },
            ),
          ),
        ));
  }
}

class ShowData extends StatelessWidget {
  final WeatherData data;
  final String cityName;

  const ShowData(this.data, this.cityName);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$cityName"),
            Text(data.temp.toString()),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 50.0,
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  // return to again notsearchingstate//
                  BlocProvider.of<BlocPattern>(context).add(ResetWeatherData());
                },
                color: Colors.blue,
                child: Text("search again"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
