import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/weather_provider.dart';

class Meteoscreen extends ConsumerStatefulWidget {
  const Meteoscreen({super.key});

  @override
  ConsumerState<Meteoscreen> createState() => _MeteoscreenState();
}

class _MeteoscreenState extends ConsumerState<Meteoscreen> {
  final TextEditingController _TextRechcontroller = TextEditingController();
  Map<String, dynamic>? _params;

  void _addToFavorites(String city) async {
    await FirebaseFirestore.instance.collection('favorites').add({
      'city': city,
      'timestamp': DateTime.now(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
         behavior: SnackBarBehavior.fixed,//permet de faire flotter le snackbar au dessus du contenu
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.teal,
        content: Text(
          "$city ajouté aux favoris",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = _params == null
        ? null
        : ref.watch(weatherProvider(_params!));

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SearchBar(
            //     controller: _TextRechcontroller,
            //     hintText: "Rechercher une ville",
            //     onSubmitted: (value) {
            //       setState(() {
            //         _params = {'lat': -4.3, 'lon': 15.3, 'city': value};
            //       });
            //     },
                // trailing: Iterable.IconButton(
                //   onPressed: () {
                //     setState(() {
                //       _params = {
                //         'lat': -4.3,
                //          'lon': 15.3, 
                //          'city': _TextRechcontroller.text
                //          };
                //     });
                //   },
                //   icon: Icon(Icons.search),
                // ),
            //),
            TextField(
              controller: _TextRechcontroller,
              decoration: InputDecoration(
                labelText: "Rechercher une ville",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _params = {
                        'lat': -4.3,
                         'lon': 15.3, 
                         'city': _TextRechcontroller.text
                         };
                    });
                  },
                  icon: Icon(Icons.search),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _params = {'lat': -4.3, 'lon': 15.3, 'city': value};
                });
              },
            ),
            const SizedBox(height: 20),
            if (weatherAsync != null)
              weatherAsync.when(
                data: (weather) => Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      weather.city,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      "${weather.temperature}°C - Vent: ${weather.windSpeed} km/h",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => _addToFavorites(weather.city),
                    ),
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Erreur: $e"),
              ),
          ],
        ),
      );
    
  }
}
