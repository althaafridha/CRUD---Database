import 'package:flutter/material.dart';

BoxDecoration boxDecoration = BoxDecoration(
  color: const Color(0xfff2f2f2),
  borderRadius: BorderRadius.circular(5),
);

buttonAsset(String text) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14 ,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}