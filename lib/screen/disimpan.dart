import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/color.dart';
import 'detail/detail_activity.dart';

class Disimpan extends StatelessWidget {
  const Disimpan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 45),
                  filled: true,
                  fillColor: greyPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Cari Resep",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              _buildBookmarkedRecipes(), // Tambahkan widget untuk menampilkan resep yang di-bookmark
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkedRecipes() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Text('Silakan login untuk melihat resep yang di-bookmark');
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('recipe')
          .where('bookmarkedBy', arrayContains: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final recipes = snapshot.data?.docs ?? [];

        if (recipes.isEmpty) {
          return const Center(child: Text('No bookmarked recipes.'));
        }

        return Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              var recipe = recipes[index].data();
              var documentId = recipes[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(
                        documentId: documentId,
                        recipe: recipe,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 145,
                      width: 145,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(recipe['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(recipe['title'])
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
