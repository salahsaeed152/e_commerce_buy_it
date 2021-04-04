import 'package:buy_it/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onSaved;

  String _errorMessage(String message){
    switch(message){
      case 'Enter your name' : return 'Name is empty';
      case 'Enter your email' : return 'Email is empty';
      case 'Enter your password' : return 'Password is empty';
      default : return 'Field required';
    }
  }

  CustomTextFormField({
    @required this.hint,
    @required this.icon,
    @required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        // ignore: missing_return
        validator: (value){
          if(value.isEmpty){
            return _errorMessage(hint);
          }
        },
        onSaved: onSaved,
        obscureText: hint == 'Enter your password' ? true : false,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          filled: true,
          fillColor: kSecondaryColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}