// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCardHomePage extends StatelessWidget {
  final Color color;
  final Text title;
  final IconData icon;
  final Function() function;
  bool? isManagement;
  CustomCardHomePage({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    required this.function,
    this.isManagement = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        color: color,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: isManagement!
                    ? Get.size.width * 0.15
                    : Get.size.width * 0.3,
              ),
            ),
            title,
          ],
        ),
      ),
    );
  }
}
