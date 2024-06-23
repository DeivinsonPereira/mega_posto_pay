import 'package:megga_posto_mobile/utils/dependencies.dart';

class BooleanMethods {
  final _billController = Dependencies.billController();

  bool isCartShoppingEmpty() {
    return _billController.cartShopping.isEmpty;
  }
}
