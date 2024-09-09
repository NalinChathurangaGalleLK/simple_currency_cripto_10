import 'package:flutter/material.dart';
import 'package:simple_currency_cripto_10/screens/price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.yellowAccent),
      home: PriceScreen(),
    );
  }
}
