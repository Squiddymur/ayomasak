import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final String uid;
  const ProfileImagePicker({required this.uid, super.key});
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedFile;
    });
  }

  Future<void> _saveProfileData() async {
    try {
      // Simpan gambar ke Firebase Storage atau sesuai kebutuhan aplikasi kamu
      String imagePath = 'images/${widget.uid}_profile_image.jpg';
      // Gantilah 'path/to/profile_images' dengan path yang sesuai di Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.putFile(File(_pickedImage!.path));
      // Pastikan kamu sudah mengaktifkan Firebase Storage di proyek kamu
      String profileImageUrl = await storageReference.getDownloadURL();
      print('URL Gambar Profil: ${_pickedImage?.path}');

      // Simpan data pengguna ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'profile_image_url': profileImageUrl,
        'uid': widget.uid,
        // Tambahkan field lain sesuai kebutuhan aplikasi kamu
      });

      // Navigasi ke halaman utama atau profil setelah menyimpan data
      Navigator.pushNamed(
          context, '/navbar'); // Gantilah dengan rute yang sesuai
    } catch (e) {
      print('Error saat menyimpan data ke Firestore: $e');
      // Handle error sesuai kebutuhan aplikasi kamu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Gambar Profil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_pickedImage != null)
            CircleAvatar(
              backgroundImage: FileImage(File(_pickedImage!.path)),
              radius: 50,
            )
          else
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pilih Gambar'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveProfileData();
            },
            child: Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }
}
