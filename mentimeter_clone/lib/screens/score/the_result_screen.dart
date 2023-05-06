import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentimeter_clone/constants.dart';

class TheResultScreen extends StatelessWidget {
  final databaseUrl = 'https://mentimeterclone-default-rtdb.firebaseio.com';

  const TheResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data as List<dynamic>;
              // Sort the data by score
              data.sort((a, b) => b['score'].compareTo(a['score']));
              return Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icons/ld.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display the sorted data
                      ...data.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                    color: kSecondaryColor, fontSize: 20),
                              ),
                              Text(
                                '${item['score']}',
                                style: const TextStyle(
                                    color: kSecondaryColor, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('No Data'),
          );
        });
  }

  // Function to fetch data from Firebase Realtime Database
  Future<List<dynamic>> _fetchData() async {
    var response = await http.get(Uri.parse('$databaseUrl/users.json'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      // Convert data to a list for easy sorting
      return jsonData.entries.map((e) => e.value).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
