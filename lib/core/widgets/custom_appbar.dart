import 'package:flutter/material.dart';


import '../utils/app_assets.dart';

class CustomAppBar extends StatelessWidget  {
  const CustomAppBar({super.key});

  @override


  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title:  Image.asset(
        AppAssets.logo,
        width: 38,
        height: 31,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}