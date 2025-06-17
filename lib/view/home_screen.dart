import 'package:flutter/material.dart';

class WeatherAppHomeScreen extends StatelessWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Weather app'), centerTitle: true));
  }
}
