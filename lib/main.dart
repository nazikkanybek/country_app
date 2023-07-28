import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  String flag =
      'https://theperfectroundgolf.com/wp-content/uploads/2022/04/placeholder.png';

  String name = 'data';
  String capital = 'data';
  String region = 'data';
  String population = 'data';
  String continent = 'data';
  String url = 'flutter.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Country App')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Введите страну',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                getData(controller.text);
              },
              child: const Icon(Icons.search),
            ),
            Image.network(flag),
            InfoWidget(data: name, title: 'Официальное название'),
            InfoWidget(data: capital, title: 'Столица'),
            InfoWidget(data: region, title: 'Регион'),
            InfoWidget(data: population, title: 'Численность населения'),
            InfoWidget(data: continent, title: 'Континент'),
            TextButton(
              onPressed: _launchUrl,
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZYmg-bGXND8sjCbNgbeYtyX4jDEBl47NTTw&usqp=CAU',
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  Future<void> getData(String countruName) async {
    try {
      final Dio dio = Dio();
      final response = await dio.get(
          'https://restcountries.com/v3.1/name/$countruName?fullText=true');

      List results = response.data;
      final result = DataModel.fromJson(results.first);

      flag = result.flags?.png ??
          'https://theperfectroundgolf.com/wp-content/uploads/2022/04/placeholder.png';

      name = result.name?.official ?? 'data';
      capital = result.capital?.first ?? 'data';
      region = result.subregion ?? 'data';
      population = '${result.population}';
      continent = result.continents?.first ?? 'data';
      url = result.maps?.googleMaps ?? 'flutter.dev';
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}

  

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.data,
    required this.title,
  });

  final String title;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const Spacer(),
          Text(
            data,
            style: const TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
