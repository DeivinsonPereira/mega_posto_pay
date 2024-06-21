import 'package:megga_posto_mobile/utils/dependencies.dart';

class ConditionToBack {
  final _billController = Dependencies.billController();

  bool condition() {
    return _billController.cartShopping.value.productAndQuantity != null &&
        _billController.cartShopping.value.productAndQuantity!.isNotEmpty &&
        _billController.cartShopping.value.supplyPump != null;
  }
}
