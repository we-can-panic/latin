import 'package:flutter/material.dart';

enum StyleType { vivid, normal, info }

Container stringToIcon(String content, {StyleType style = StyleType.normal}) {
  switch (style) {
    case StyleType.vivid:
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightGreen,
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case StyleType.info:
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black45,
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      );
    case StyleType.normal:
    default:
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      );
  }
}
