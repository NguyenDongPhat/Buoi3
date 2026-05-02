import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Weather'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search city name',
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WeatherProvider>().fetchWeatherByCity(value);
                }
              },
            ),
          ),
          if (_searchController.text.isEmpty)
            Expanded(
              child: ListView(
                children: [
                  if (provider.favoriteCities.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Favorite Cities',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          ...provider.favoriteCities.map((city) {
                            return ListTile(
                              leading: Icon(Icons.star, color: Colors.yellow),
                              title: Text(city),
                              onTap: () {
                                context.read<WeatherProvider>().fetchWeatherByCity(city);
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  if (provider.searchHistory.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search History',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          ...provider.searchHistory.map((city) {
                            return ListTile(
                              leading: Icon(Icons.history),
                              title: Text(city),
                              onTap: () {
                                context.read<WeatherProvider>().fetchWeatherByCity(city);
                              },
                              trailing: IconButton(
                                icon: Icon(
                                  provider.favoriteCities.contains(city)
                                      ? Icons.star
                                      : Icons.star_outline,
                                  color: provider.favoriteCities.contains(city)
                                      ? Colors.yellow[700]
                                      : null,
                                ),
                                onPressed: () {
                                  if (provider.favoriteCities.contains(city)) {
                                    provider.removeFavoriteCity(city);
                                  } else {
                                    provider.addFavoriteCity(city);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                ],
              ),
            )
          else
            Expanded(
              child: Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  if (provider.state == WeatherState.loading) {
                    return LoadingShimmer();
                  }
                  
                  if (provider.state == WeatherState.error) {
                    return ErrorWidgetCustom(
                      message: provider.errorMessage,
                      onRetry: () => context.read<WeatherProvider>().fetchWeatherByCity(_searchController.text),
                    );
                  }
                  
                  if (provider.currentWeather == null) {
                    return Center(child: Text('No weather data'));
                  }
                  
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CurrentWeatherCard(weather: provider.currentWeather!),
                        ...provider.forecast
                            .take(5)
                            .map((forecast) => DailyForecastCard(forecast: forecast))
                            .toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
