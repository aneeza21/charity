import 'package:dono/firebase_options.dart';
import 'package:dono/pages/charity_signup.dart';
import 'package:dono/pages/shop_home.dart';
import 'package:dono/pages/profile.dart';
import 'package:dono/pages/shop_signup.dart';
import 'package:dono/providers/shop_ownerprovider.dart';
import 'package:dono/providers/user_provider.dart';
import 'package:dono/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dono/pages/charity_login.dart';
import 'package:dono/pages/donor_login.dart';
import 'package:dono/pages/identity_page.dart' as identityPage;
import 'package:dono/pages/shop_login.dart';
import 'package:dono/pages/start_page.dart' as startPage;
import 'package:dono/pages/donor_signup.dart';
import 'package:provider/provider.dart';
import 'package:dono/pages/item_list_page.dart';
import './charity/resetpass.dart';
import './charity/charityhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ShopOwnerProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: startPage.StartPage(),
      routes: {
        '/identity_page': (context) => identityPage.IdentityPage(),
        '/donor_login': (context) => DonorLogin(),
        '/shop_login': (context) => ShopLogin(),
        '/charity_login': (context) => CharityLogin(),
        '/donor_signup': (context) => DonorSignupPage(),
        '/charity_signup': (context) => CharitySignupPage(),
        '/shop_signup': (context) => ShopSignupPage(),
        '/shop_home': (context) => ShopHome(),
         '/resetpass': (context) => ResetPass(),
        '/charity_home': (context) => CharityHome(),
      },
    );
  }
}
