import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const MyImage({
    super.key,
     required this.imagePath,
     required this.onTap,
     });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200
        ),
        child: Image.asset(
          imagePath,
          height: 60  ,
        ),
      ),
    );
  }
}