import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/train_provider.dart';
import 'screens/home_screen.dart';
import 'providers/seat_selection_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SeatSelectionProvider()),
        ChangeNotifierProvider(create: (context) => TrainProvider()),
      ],
      child: MaterialApp(
        title: '기차 예매',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
