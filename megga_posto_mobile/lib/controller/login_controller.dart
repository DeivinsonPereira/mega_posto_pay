import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  String login = '';
  int idAtendente = 0;
}
