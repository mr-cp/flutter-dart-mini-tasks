// Task 4::::::
// Fetch and Display User List:::::

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masonry_list_view_grid/masonry_list_view_grid.dart';

class UserFetching extends StatefulWidget {
  const UserFetching({super.key});

  @override
  State<UserFetching> createState() => _UserFetchingState();
}

class _UserFetchingState extends State<UserFetching> {
  Future<List<dynamic>> fetchDetails() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('something went wrong');
      }
    } catch (e) {
      print('some error caught $e');
    }
    return [];
  }

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchDetails(),
          builder: (context, snapshot) {
            final user = snapshot.data!;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No user found'));
            }

            return MasonryListViewGrid(
              column: 2,
              padding: const EdgeInsets.all(8.0),
              children: List.generate(
                user.length,
                (index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          name: user[index]['name'],
                          email: user[index]['email'],
                          suite: user[index]['address']['suite'],
                          city: user[index]['address']['city'],
                          zipcode: user[index]['address']['zipcode'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                    height: (150 + (index % 3 == 0 ? 100 : 0)).toDouble(),
                    child: Center(
                      child: Text(user[index]['name']),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String name;
  final String email;

  final String suite;
  final String city;
  final String zipcode;

  const DetailScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.suite,
      required this.city,
      required this.zipcode});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name),
            Text(widget.email),
            Text(widget.suite),
            Text(widget.city),
            Text(widget.zipcode),
          ],
        ),
      ),
    );
  }
}
