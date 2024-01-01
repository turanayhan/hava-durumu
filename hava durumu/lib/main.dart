import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = '4a1351ed01b8d223bf8c10e50e9524c4';
  final String city = 'malatya';
  final String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={4a1351ed01b8d223bf8c10e50e9524c4}';

  Future<Map<String, dynamic>> getWeather() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu Uygulaması'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Hava durumu bilgileri alınamıyor.'));
            } else {
              final weatherData = snapshot.data;
              final temperature = weatherData?['main']?['temp'];
              final description = weatherData?['weather']?[0]?['description'];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wb_sunny,
                      size: 100,
                      color: Colors.yellow,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '$city Hava Durumu',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$temperature°C',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$description',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
