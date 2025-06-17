import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyScreen extends StatefulWidget {
  final String city;
  final Map<String, dynamic> currentValue;
  final List<dynamic> hourly;
  final List<dynamic> pastWeek;
  final List<dynamic> next7days;

  const WeeklyScreen({
    super.key,
    required this.city,
    required this.currentValue,
    required this.hourly,
    required this.pastWeek,
    required this.next7days,
  });

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  String formatApiData(String dataString) {
    DateTime date = DateTime.parse(dataString);
    return DateFormat('d MMM, EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.city,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '${widget.currentValue['temp_c']}°C',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '${widget.currentValue['condition']['text']}',
                      style: TextStyle(fontSize: 22, color: theme.colorScheme.onPrimary),
                    ),
                    Image.network(
                      'https:${widget.currentValue['condition']?['icon'] ?? ''}',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              // 7 next days
              SizedBox(height: 20),
              Text(
                'Next 7 Days Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 20),
              ...widget.next7days.map((day) {
                final data = day['date'] ?? '';
                final condition = day['day']?['condition']?['text'] ?? '';
                final icon = day['day']?['condition']?['icon'] ?? '';
                final maxTemp = day['day']?['maxtemp_c'] ?? '';
                final minTemp = day['day']?['mintemp_c'] ?? '';

                return ListTile(
                  leading: Image.network('https:$icon', width: 40),
                  title: Text(
                    formatApiData(data),
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  subtitle: Text(
                    '$condition $minTemp°C - $maxTemp°C',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                );
              }),
              // Previous 7 next days
              SizedBox(height: 20),
              Text(
                'Previous 7 Days Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 10),
              ...widget.pastWeek.map((day) {
                final forecastDay = day['forecast']?['forecastday'];
                if (forecastDay == null || forecastDay.isEmpty) {
                  return SizedBox.shrink();
                }
                final forecast = forecastDay[0];
                final data = forecast['date'] ?? '';
                final condition = forecast['day']?['condition']?['text'] ?? '';
                final icon = forecast['day']?['condition']?['icon'] ?? '';
                final maxTemp = forecast['day']?['maxtemp_c'] ?? '';
                final minTemp = forecast['day']?['mintemp_c'] ?? '';

                return ListTile(
                  leading: Image.network('https:$icon', width: 40),
                  title: Text(
                    formatApiData(data),
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  subtitle: Text(
                    '$condition $minTemp°C - $maxTemp°C',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
