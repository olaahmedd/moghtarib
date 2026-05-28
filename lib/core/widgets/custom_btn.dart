import 'package:flutter/material.dart';
import 'package:moghtarib/core/utils/app_assets.dart';
import 'package:moghtarib/core/utils/app_colors.dart';


class CustomBtn extends StatelessWidget {
  const CustomBtn({super.key, required this.text, required this.onPressed});
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 327,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:AppColors.primary,
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          text,
           style: TextStyle(color:AppColors.grey,)
        ),
      ),
    );
  }
}