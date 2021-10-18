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
          centerTitle: true,
          title: Text(
            'Bloc Pattern',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.cyanAccent,
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
                            color: Colors.cyanAccent,
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(data.temp.toString()),
              Container(
                height: 50.0,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubScreen(
                          cityName: cityName,
                          data: data,
                        ),
                      ),
                    );
                  },
                  color: Colors.cyanAccent,
                  child: Text("show city details"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50.0,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    // return to again notsearchingstate//
                    BlocProvider.of<BlocPattern>(context)
                        .add(ResetWeatherData());
                  },
                  color: Colors.cyanAccent,
                  child: Text("search another city"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubScreen extends StatefulWidget {
  final WeatherData data;
  final String cityName;

  SubScreen({required this.data, required this.cityName});

  @override
  _SubScreenState createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  final weatherBloc = BlocPattern(NotSearchingState());
  int click = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: Colors.cyanAccent,
          title: Text("${widget.cityName.toUpperCase()}",
              style: TextStyle(color: Colors.black)),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.data.temp.toString()),
            StreamBuilder(
                stream: weatherBloc.stateStream,
                builder: (context, snapshot) {
                  return (snapshot.hasData)
                      ? Text("New Data:" + snapshot.data.toString())
                      : Text('----');
                }),
            MaterialButton(
              child: Text('Fetch again'),
              onPressed: () {
                weatherBloc.add(GetWeatherData(cityName: widget.cityName));
              },
            )
          ],
        )));
  }
}
