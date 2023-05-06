import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderBoardScreen extends StatelessWidget {
  final databaseUrl = 'https://mentimeterclone-default-rtdb.firebaseio.com';

  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            var data = snapshot.data as List<dynamic>;
            // Sort the data by score
            data.sort((a, b) => b['score'].compareTo(a['score']));

            return Stack(
              children: [
                ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            '${item['score']}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
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
