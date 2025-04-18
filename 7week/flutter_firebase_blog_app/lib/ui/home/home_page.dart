import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLOG')),
      body: Column(
        children: [
          //
          Text('최근글', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
