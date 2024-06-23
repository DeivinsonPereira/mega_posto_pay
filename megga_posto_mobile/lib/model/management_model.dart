// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ManagementModel {
  Color color;
  IconData icon;
  Text title;
  Function() function;
  
  ManagementModel({
    required this.color,
    required this.icon,
    required this.title,
    required this.function,
  });
}
