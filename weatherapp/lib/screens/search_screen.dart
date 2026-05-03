import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  void _handleSearch(BuildContext context, String cityName) {
    if (cityName.trim().isNotEmpty) {
      context.read<WeatherProvider>().fetchWeatherByCity(cityName.trim());
      Navigator.pop(context);
    }
  }

  void _handleLocateMe(BuildContext context) {
    context.read<WeatherProvider>().fetchWeatherByLocation();
    Navigator.pop(context);
  }

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
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search city name (e.g. Hanoi)',
                prefixIcon: Icon(Icons.search), 
                
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.my_location, color: Colors.blue), 
                        tooltip: 'Current Location',
                        onPressed: () => _handleLocateMe(context), 
                      ),
                      
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {}); 
              },
              onSubmitted: (value) => _handleSearch(context, value),
            ),
          ),
          
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
                            leading: Icon(Icons.star, color: Colors.yellow[700]),
                            title: Text(city),
                            onTap: () => _handleSearch(context, city),
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
                            onTap: () => _handleSearch(context, city),
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