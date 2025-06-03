// 📷 Task 2:::::
// Image Grid Viewer



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Future<List<String>> fetchImage() async {
    final url = Uri.parse('https://picsum.photos/v2/list?page=2&limit=100');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List;

      return jsonData.map((item) => item['download_url'] as String).toList();
    } else {
      throw Exception('some error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: fetchImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No images found'),
                );
              }
              final imageList = snapshot.data!;
              return GridView.builder(
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  print('imageList:::::$imageList');
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                    imgUrl: imageList[index],
                                  )));
                    },
                    child: Image.network(imageList[index]),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
              );
            }));
  }
}

class DetailScreen extends StatelessWidget {
  final String imgUrl;
  const DetailScreen({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(imgUrl),
    );
  }
}
