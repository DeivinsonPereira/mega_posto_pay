import 'package:megga_posto_mobile/utils/dependencies.dart';

class BooleanMethods {
  final _billController = Dependencies.billController();

  bool isCartShoppingEmpty() {
    return _billController.cartShopping.isEmpty;
  }

  bool isSupplyPumpEmpty() {
    return _billController.cartShopping.where((element) => element.supplyPump != null).isEmpty;
  }

  bool isProductEmpty() {
    return _billController.cartShopping.where((element) => element.productAndQuantity != null).isEmpty;
  }
}
