import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> dataDiri;

  const EditProfile({required this.uid, required this.dataDiri, super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  XFile? _pickedImage;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengatur nilai awal pada _nameController sesuai data di Firestore
    _nameController.text = widget.dataDiri['name'] ?? '';
    String imageUrl = widget.dataDiri['profile_image_url'] ?? '';
    if (imageUrl.isNotEmpty) {
      _pickedImage = XFile(imageUrl);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _updateRecipeOwnerName(String uid, String updatedName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update semua resep yang dimiliki oleh pengguna dengan nama pengguna yang baru
      await firestore
          .collection('recipe')
          .where('ownerUid', isEqualTo: uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((recipeDoc) {
          recipeDoc.reference.update({'ownerName': updatedName});
        });
      });
    } catch (error) {
      print('Error updating recipe ownerName: $error');
    }
  }

  Future<void> _saveProfileData() async {
    try {
      // Handling if _pickedImage is a network image
      if (_pickedImage != null && !_pickedImage!.path.startsWith('http')) {
        // Save the image to Firebase Storage
        String imagePath = 'images/${widget.uid}_profile_image.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        await storageReference.putFile(File(_pickedImage!.path));
        String profileImageUrl = await storageReference.getDownloadURL();

        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'profile_image_url': profileImageUrl,
          'name': _nameController.text,
        });
        await _updateRecipeOwnerName(widget.uid, _nameController.text);
      } else {
        // Check if the name has been modified
        String updatedName = _nameController.text.trim();
        String existingName = widget.dataDiri['name'] ?? '';

        if (updatedName.isNotEmpty && updatedName != existingName) {
          // Update only the name if it has been modified
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .update({
            'name': updatedName,
          });
          await _updateRecipeOwnerName(widget.uid, updatedName);
        }
      }

      // Navigate back to the main page or profile page
      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile data to Firestore: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Gambar Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_pickedImage != null && !_pickedImage!.path.startsWith('http'))
              CircleAvatar(
                backgroundImage: FileImage(File(_pickedImage!.path)),
                radius: 50,
              )
            else
              CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(widget.dataDiri['profile_image_url'])),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pilih Gambar'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveProfileData();
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }
}
