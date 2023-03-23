import 'package:flutter/material.dart';

class TextFormFieldWithTrailingIcon extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressedClear;
  final VoidCallback onTap;
  final String hitText;
  final bool readOnly;

  TextFormFieldWithTrailingIcon({
    required this.controller,
    required this.onPressedClear,
    required this.hitText,
    required this.onTap,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hitText,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.highlight_remove_outlined,
            color: Colors.white24,
          ),
          onPressed: onPressedClear,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter input';
        }
        return null;
      },
    );
  }
}
