import 'package:flutter/material.dart';
class DefaultTextField extends StatelessWidget {
  const DefaultTextField(
      {super.key,
      required this.hintText,
      this.prefixIconData,
      this.suffixIcon,
      this.obscureText = false,
      required this.controller,
      this.validator,this.readOnly = false, 
    this.onTap});

  final String hintText;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly; 
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      readOnly: readOnly, 
      onTap: onTap,
      style: TextStyle(fontSize: 14, color: Colors.black),
      obscureText: obscureText,
      obscuringCharacter: '*',
       decoration:InputDecoration(
      
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ));

  }
}