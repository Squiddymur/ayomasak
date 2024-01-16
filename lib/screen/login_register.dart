import 'package:flutter/material.dart';
import 'package:ayomakan/styles/color.dart';
import 'package:ayomakan/styles/button.dart';

class LoginRegister extends StatelessWidget {
  static String routeName = "loginregister";
  const LoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: greenPrimary,
            body: Center(
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'images/food background 1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 320),
                      alignment: Alignment.center,
                      child: Column(children: [
                        Image.asset('images/logoayomasakputihpotrait 3.png'),
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Memasak dengan penuh ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'pertimbangan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 200, left: 40),
                          child: Row(children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: buttonDaftar,
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  style: buttonMasuk,
                                  child: const Text('Masuk',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                            )
                          ]),
                        )
                      ]))
                ],
              ),
            )));
  }
}
