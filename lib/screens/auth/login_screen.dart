import 'package:buy_it/provider/auth_view_model.dart';
import 'package:buy_it/provider/model_hud.dart';
import 'package:buy_it/screens/auth/signup_screen.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:buy_it/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final _autViewModel = Provider.of<AuthViewModel>(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: widget.globalKey,
          child: ListView(
            children: [
              CustomLogo(
                imageName: 'icon_buy_100.png',
                text: 'Buy it',
              ),
              SizedBox(height: height * 0.1),
              CustomTextFormField(
                hint: 'Enter your email',
                icon: Icons.email,
                onSaved: (value) {
                  _autViewModel.email = value;
                },
              ),
              SizedBox(height: height * 0.02),
              CustomTextFormField(
                hint: 'Enter your password',
                icon: Icons.lock,
                onSaved: (value) {
                  _autViewModel.password = value;
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: kSecondaryColor,
                        activeColor: kMainColor,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () async
                    {
                      if (widget.globalKey.currentState.validate()) {
                        widget.globalKey.currentState.save();
                        if (keepMeLoggedIn == true) {
                          _autViewModel.keepUserLoggedIn(keepMeLoggedIn);
                        }
                        await _autViewModel
                            .signInWithEmailAndPasswordMethod(context);
                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        final pref = preferences.getBool(kKeepMeLoggedIn);
                        print(pref);
                      }},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.id);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
