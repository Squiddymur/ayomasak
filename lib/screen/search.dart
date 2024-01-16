import 'package:ayomakan/screen/Home/Components/list.dart';
import 'package:ayomakan/screen/detail/detail_activity.dart';
import 'package:ayomakan/styles/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cari extends StatefulWidget {
  const Cari({super.key});

  @override
  _CariState createState() => _CariState();
}

class _CariState extends State<Cari> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedFilterCategory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 45),
                  filled: true,
                  fillColor: greyPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Temukan Resep",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                maxLines: 1,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterButton('Sarapan'),
                  _buildFilterButton('Makan Siang'),
                  _buildFilterButton('Makan Malam'),
                  _buildFilterButton('Snack'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String category) {
    bool isActive = selectedFilterCategory == category;

    return ElevatedButton(
      onPressed: () {
        if (isActive) {
          // Jika tombol yang sedang aktif ditekan lagi, berhenti filter
          _clearFilter();
        } else {
          // Jika tombol yang tidak aktif ditekan, aktifkan filter
          _updateFilter(category);
        }
      },
      style: ButtonStyle(
        backgroundColor: isActive
            ? MaterialStateProperty.all(
                Colors.blue) // Ganti warna yang diinginkan
            : null,
        // Tambahkan dekorasi tambahan untuk tombol yang aktif jika diinginkan
        // contoh:
        // border: isActive
        //     ? MaterialStateProperty.all(Border.all(color: Colors.red))
        //     : null,
      ),
      child: Text(category),
    );
  }

  void _clearFilter() {
    setState(() {
      selectedFilterCategory = null;
    });
    // Panggil metode _fetchRecipesFromFirestore() lagi untuk memuat ulang data tanpa filter
    _fetchRecipesFromFirestore();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _fetchRecipesFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final recipes = snapshot.data?.docs ?? [];

        // Filter recipes based on the search query

        final filteredRecipes = recipes.where((recipe) {
          final ownerUid = recipe['ownerUid'];
          final currentUserUID = FirebaseAuth.instance.currentUser?.uid;
          return ownerUid != currentUserUID;
        }).toList();

        return ListView.builder(
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            var recipe = filteredRecipes[index].data();
            var documentId = filteredRecipes[index].id;

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
                  // Your recipe display widget
                  // Modify as per your UI requirements
                  Item(recipe: recipe, documentId: documentId)
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateFilter(String category) {
    setState(() {
      selectedFilterCategory = category;
    });
    // Panggil metode _fetchRecipesFromFirestore() lagi untuk memuat ulang data dengan filter
    _fetchRecipesFromFirestore();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchRecipesFromFirestore() {
    Query query = FirebaseFirestore.instance.collection('recipe');
    if (selectedFilterCategory != null) {
      query = query.where('category', isEqualTo: selectedFilterCategory);
    }

    if (_searchQuery.isNotEmpty) {
      query = query
          .orderBy('title')
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThanOrEqualTo: '${_searchQuery}z');
    }

    return query.snapshots(includeMetadataChanges: true)
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }
}
