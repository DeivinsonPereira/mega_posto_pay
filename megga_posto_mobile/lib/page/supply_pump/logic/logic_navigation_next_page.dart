import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/supply_pump_model.dart';
import 'package:megga_posto_mobile/utils/boolean_methods.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_features.dart';

import '../../../model/supply_model.dart';
import '../../cart_shopping/cart_shopping_page.dart';

class LogicNavigationNextPage {
  final _billFeatures = BillFeatures();

  LogicNavigationNextPage._privateConstructor();

  static final LogicNavigationNextPage _instance =
      LogicNavigationNextPage._privateConstructor();

  factory LogicNavigationNextPage() => _instance;

  Future<void> nextPage(Supply supplySelected,
      {SupplyPump? supplyPumpSelected}) async {
    if (supplyPumpSelected != null) {
      _billFeatures.addCartShoppingListFromSupply(
          supplyPump: supplyPumpSelected);
    }
/*
    if (BooleanMethods().isProductEmpty()) {
      _navigation(const PaymentPage());
      return;
    }
*/
    if (BooleanMethods().isCartShoppingEmpty()) {
      const CustomCherryError(message: 'Nenhum produto adicionado no carrinho')
          .show(Get.context!);
      return;
    }

    _navigation(const CartShoppingPage());
  }

  void _navigation(Widget page) {
    Get.to(() => page, transition: Transition.rightToLeft);
  }
}
