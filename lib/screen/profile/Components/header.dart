import 'package:ayomakan/screen/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../styles/Text.dart';
import '../../../styles/button.dart';

class ProfileHead extends StatelessWidget {
  final String uid;

  const ProfileHead({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error state
          return Text('Error: ${snapshot.error}');
        } else {
          // Data loaded successfully
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String nama = userData['name'] ??
              ''; // Ganti 'nama' dengan field yang sesuai di Firestore
          String imageUrl = userData['profile_image_url'] ??
              ''; // Ganti 'image_url' dengan field yang sesuai di Firestore

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: judulDetail,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: buttonIkuti,
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => EditProfile(uid: uid),
                              //     ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            uid: uid,
                                            dataDiri: userData,
                                          )));
                            },
                            child: const Text(
                              'Edit Profil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 Diikuti',
                                  style: smallText,
                                ),
                                Text(
                                  '1 Resep',
                                  style: smallText,
                                ),
                                Text(
                                  '0 Pengikut',
                                  style: smallText,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
