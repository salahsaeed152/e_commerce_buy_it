import 'package:flutter/material.dart';
class CustomLogo extends StatelessWidget {
  final String imageName;
  final String text;

  CustomLogo({@required this.imageName, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('images/icons/$imageName'),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}