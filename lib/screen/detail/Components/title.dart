import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../styles/Text.dart';

class Judul extends StatelessWidget {
  final int recipe;
  const Judul({super.key, required this.recipe, required int recipeId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchRecipe(context, recipe),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final recipe = snapshot.data;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 266,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(recipe!['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
              ),
            ),
            Text(recipe['title'], style: judulDetail),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Resep oleh: ',
                  style: hintTextDetail,
                ),
                Text(
                  "Squiddymur",
                  style: resepPembuatDetail,
                )
              ],
            ),
            Text(
              recipe['time'],
              style: hintTextDetail,
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchRecipe(
      BuildContext context, int recipeId) async {
    // Assuming you have a method to fetch a single recipe by its ID from Firestore
    // Implement your logic to fetch data from Firestore here
    // For example:
    var recipeDocument = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId.toString())
        .get();
    var recipeData = recipeDocument.data() as Map<String, dynamic>;
    return recipeData;
// Replace with your actual implementation
  }
}
