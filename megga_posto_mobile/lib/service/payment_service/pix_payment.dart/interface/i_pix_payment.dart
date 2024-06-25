import 'package:flutter/material.dart';

abstract class IPixPayment {
  Future<void> payment({BuildContext context});
}
