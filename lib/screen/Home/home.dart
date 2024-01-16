import 'package:ayomakan/screen/Home/Components/header.dart';
import 'package:ayomakan/screen/Home/Components/scroll_section.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ListView(
            children: const [
              Header(),
              Scroll(),
            ],
          ),
        ),
      ),
    );
  }
}
