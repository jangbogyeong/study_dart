import 'package:flutter/material.dart';

class StationListScreen extends StatelessWidget {
  final String title;

  const StationListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final stations = [
      '수서',
      '동탄',
      '평택지제',
      '천안아산',
      '오송',
      '대전',
      '김천구미',
      '동대구',
      '경주',
      '울산',
      '부산',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: stations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              stations[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            onTap: () => Navigator.pop(context, stations[index]),
          );
        },
      ),
    );
  }
}
