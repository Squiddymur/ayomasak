import 'package:ayomakan/screen/Home/Components/view.dart';
import 'package:ayomakan/styles/Text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../detail/detail_activity.dart';
import '../Components/list.dart';

class Scroll extends StatefulWidget {
  const Scroll({Key? key}) : super(key: key);

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Diikuti',
            style: kategori,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildHorizontalScroll(),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Terbaru',
            style: kategori,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildVerticalScroll(),
      ],
    );
  }

  Widget _buildHorizontalScroll() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _fetchRecipesFromFirestore(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final recipes = snapshot.data?.docs ?? [];

        if (recipes.isEmpty) {
          return const Center(
            child: Text('Resep Kosong'),
          );
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
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
                child: MyViewList(
                  recipe: recipe,
                  documentId: documentId,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVerticalScroll() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _fetchRecipesFromFirestore(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final recipes = snapshot.data?.docs ?? [];

        if (recipes.isEmpty) {
          return const Center(
            child: Text('Resep Kosong'),
          );
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
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
                child: Item(
                  documentId: documentId,
                  recipe: recipe,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchRecipesFromFirestore() {
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('recipe')
        .where('ownerUid',
            isNotEqualTo:
                currentUserUID) // Only fetch recipes that are not owned by the currently logged-in user
        .orderBy('ownerUid')
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true);
  }
}
