import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/auth_view_model.dart';
import 'package:buy_it/provider/cart_model_view.dart';
import 'package:buy_it/provider/manage_product_view_model.dart';
import 'package:buy_it/provider/model_hud.dart';
import 'package:buy_it/screens/cart_screen.dart';
import 'package:buy_it/screens/home_screen.dart';
import 'package:buy_it/screens/product_info.dart';
import 'file:///C:/Users/DELL/AndroidStudioProjects/buy_it/lib/screens/auth/login_screen.dart';
import 'file:///C:/Users/DELL/AndroidStudioProjects/buy_it/lib/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Loading....'),
                ),
              ),
            );
          } else {
            isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
            return MultiProvider(
              providers:
              [
                ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),
                ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel()),
                ChangeNotifierProvider<ManageProductViewModel>(create: (context) => ManageProductViewModel()),
                ChangeNotifierProvider<CartModelView>(create: (context) => CartModelView()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: isUserLoggedIn ? HomePage.id : LoginScreen.id,
                routes: {
                  LoginScreen.id: (context) => LoginScreen(),
                  SignUpScreen.id: (context) => SignUpScreen(),
                  HomePage.id: (context) => HomePage(),
                  ProductInfo.id: (context) => ProductInfo(),
                  CartScreen.id: (context) => CartScreen(),
                },
              ),
            );
          }
        }
          );
  }
}
