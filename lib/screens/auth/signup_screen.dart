import 'package:buy_it/provider/auth_view_model.dart';
import 'package:buy_it/provider/model_hud.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:buy_it/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SignUpScreen extends StatelessWidget {
  static String id = 'SignUpScreen';

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _autViewModel = Provider.of<AuthViewModel>(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: globalKey,
          child: ListView(
            children: [
              CustomLogo(
                imageName: 'icon_buy_100.png',
                text: 'Buy it',
              ),
              SizedBox(height: height * 0.1),
              CustomTextFormField(
                hint: 'Enter your name',
                icon: Icons.perm_identity,
                onSaved: (value) {
                  _autViewModel.name = value;
                },
              ),
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () async {
                      if(globalKey.currentState.validate()){
                        globalKey.currentState.save();
                      await _autViewModel.signUpWithEmailAndPasswordMethod(context);
                    }
                      },
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
                      'Sign up',
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
                    'Already have an account ? ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
