import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  RoundedButton({required this.buttonText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.lightBlueAccent,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: Colors.white.withOpacity(0.3),
          onTap: onPressed as void Function()?,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class BackButtonB extends StatelessWidget {
  final VoidCallback onPressed;

  BackButtonB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            // color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}

class HamButtonB extends StatelessWidget {
  final VoidCallback onPressed;

  HamButtonB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(
            Icons.menu_sharp,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}

