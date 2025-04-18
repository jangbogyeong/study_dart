import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('name : '),
          Text('age : '),
          ElevatedButton(onPressed: () {}, child: Text('데이터 가져오기')),
        ],
      ),
    );
  }
}
