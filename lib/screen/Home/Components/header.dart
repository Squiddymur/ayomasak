import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Squiddymur',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'temukan resepmu hari ini',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/profile.png"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
