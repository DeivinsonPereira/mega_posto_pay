import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/boolean_methods.dart';

import '../../../common/custom_cherry.dart';
import '../../../utils/dependencies.dart';
import '../../cart_shopping/cart_shopping_page.dart';

class LogicProductConfirmButton {
  var billController = Dependencies.billController();

  void executeLogic(BuildContext context) {
    if (BooleanMethods().isCartShoppingEmpty()) {
      const CustomCherryError(message: 'O carrinho está vazio!').show(context);
    } else {
      Get.to(() => const CartShoppingPage());
    }
  }
}
