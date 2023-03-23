import 'package:flutter/material.dart';

Widget materialButton(onPressed,text,context){
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: MediaQuery.of(context).size.width-100,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
    ),
  );
}

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
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.lightBlueAccent,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
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
