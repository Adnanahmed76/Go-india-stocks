import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String? _errorMessage;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather("Philadelphia");
  }

  void _fetchWeather(String cityName) {
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
        _errorMessage = null; 
      });
    }).catchError((error) {
      setState(() {
        _errorMessage = "Error fetching weather data: ${error.toString()}";
        _weather = null; // Clear weather data if there's an error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: _buildUi(),
        ),
      ),
    );
  }

  Widget _buildUi() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _fetchWeather(_controller.text);
                },
              ),
            ],
          ),
        ),
        _errorMessage != null
            ? Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            : _weather == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _locationHeader(),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                        _dateTimeInfo(),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                        _weatherIcon(),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                        _currentTemp(),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(
            fontSize: 35,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Text(
              "${DateFormat("d.M.y").format(now)}",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
            "https://imgs.search.brave.com/hYhiKJDup3uZ79dMyZs1zhVMAnXdUvFeX8giLYUalAo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jb21t/dW5pdHkuaG9tZS1h/c3Npc3RhbnQuaW8v/aW1hZ2VzL2Vtb2pp/L3R3aXR0ZXIvc3Vu/X2JlaGluZF9yYWlu/X2Nsb3VkLnBuZz92/PTEy"),
        SizedBox(height: 10),
        Text(_weather?.weatherDescription ?? "")
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: TextStyle(
          color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500),
    );
  }
}
