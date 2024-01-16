import 'package:ayomakan/screen/Home/home.dart';
import 'package:ayomakan/screen/create/create.dart';
import 'package:ayomakan/screen/disimpan.dart';
import 'package:ayomakan/screen/getstarted.dart';
import 'package:ayomakan/screen/login.dart';
import 'package:ayomakan/screen/login_register.dart';
import 'package:ayomakan/screen/profile/profile.dart';
import 'package:ayomakan/screen/register.dart';
import 'package:ayomakan/screen/search.dart';
import 'package:ayomakan/styles/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: greyBackground,
          useMaterial3: true,
          fontFamily: "Inter"),
      home: isLogin ? const Navbar() : const GetStarted(),
      initialRoute: '/',
      routes: {
        '/home': (context) => const Home(),
        '/loginregister': (context) => const LoginRegister(),
        '/register': (context) => const Register(),
        '/login': (context) => Login(),
        '/navbar': (context) => const Navbar()
      },
    );
  }
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  int currentPageIndex = 0;

  final labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenPrimary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCreate()),
          );
          // recipeModel.addRecipe(Recipe(
          //     id: 1,
          //     namaMakanan: "asdasdasd",
          //     resepPembuat: "asdasd",
          //     waktu: "asdasd",
          //     assetImage: 'images/5f69e601777db 1.png'));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: greyPrimary, width: 0.5))),
        child: NavigationBar(
          elevation: 0,
          height: 70,
          labelBehavior: labelBehavior,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: greenPrimary,
          backgroundColor: Colors.white,
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              icon: Icon(Icons.search_outlined),
              label: 'Cari',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              icon: Badge(child: Icon(Icons.bookmark_outline)),
              label: 'Disimpan',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Badge(
                child: Icon(Icons.person_outline),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const Home(),
        const Cari(),
        const Disimpan(),
        const Profil()
      ][currentPageIndex],
    );
  }
}
