import 'package:buy_it/models/product_model.dart';
import 'package:buy_it/provider/auth_view_model.dart';
import 'package:buy_it/screens/auth/login_screen.dart';
import 'package:buy_it/screens/cart_screen.dart';
import 'package:buy_it/widgets/tap_product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthViewModel _authViewModel;
  User _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;

  List<ProductModel> _products ;

  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: kUnActiveColor,
              currentIndex: _bottomBarIndex,
              fixedColor: kMainColor,
              onTap: (value) async {
                if(value == 1){
                  // Navigator.popAndPushNamed(context, CartScreen.id);
                } else if (value == 2) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.clear();
                  await _authViewModel.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
                setState(() {
                  _bottomBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                    label: 'Home', icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: 'Cart', icon: Icon(Icons.shopping_cart)),
                BottomNavigationBarItem(
                    label: 'Sign Out', icon: Icon(Icons.close)),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  Text(
                    'Jackets',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Trouser',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'T-shirts',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Shoes',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                tapProductView(kJackets, _products, context),
                tapProductView(kTrousers, _products, context),
                tapProductView(kT_shirts, _products, context),
                tapProductView(kShoes, _products, context),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    getCurrentUser();
  }

  getCurrentUser() async {
    _loggedUser = await FirebaseAuth.instance.currentUser;
    print('_loggedUser= ${_loggedUser.email}');
  }

}
