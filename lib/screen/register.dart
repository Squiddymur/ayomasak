import 'package:ayomakan/screen/profile_picker.dart';
import 'package:ayomakan/styles/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isChecked = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginregister');
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 10),
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, left: 15),
                child: const Text(
                  'Simpan resep lezat dan dapatkan  konten pribadimu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 20, top: 25),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nama',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 20, top: 25),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, right: 20, top: 25),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Checkbox(
                      value: isChecked,
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Saya menyetujui Syarat Dan Ketentuan dan Kebijakan Privasi yang berlaku',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: ElevatedButton(
                    style: buttonSimpan,
                    onPressed: isChecked
                        ? () async {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              // Store user data in Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'name': nameController.text,
                                'email': emailController.text,
                                // Add more fields as needed
                              });
                              String uid = userCredential.user!.uid;
                              // Navigate to profile image picker
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileImagePicker(uid: uid),
                                ),
                              );
                            } catch (e) {
                              print("Error during registration: $e");
                              // Handle error registrasi di sini
                            }
                          }
                        : null,
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sudah memiliki akun?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
