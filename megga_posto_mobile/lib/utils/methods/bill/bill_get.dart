import 'package:megga_posto_mobile/controller/bill_controller.dart';
import 'package:megga_posto_mobile/model/collections/product.dart';
import 'package:megga_posto_mobile/model/supply_pump_model.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import '../../../model/cart_shopping_model.dart';

class BillGet {
  final _billController = Dependencies.billController();

  BillGet._privateConstructor();

  static final BillGet _instance = BillGet._privateConstructor();

  factory BillGet() => _instance;

  // Retorna a quantidade de todos os produtos do carrinho
  int calculateTotalQuantityFromCart() {
    int totalQuantityFromCart = 0;
    List<CartShoppingModel> cartShopping = _billController.cartShopping
        .where((element) => element.productAndQuantity != null)
        .toList();

    if (cartShopping.isNotEmpty) {
      for (var item in cartShopping) {
        totalQuantityFromCart += item.productAndQuantity!.quantity!;
      }
    }

    cartShopping = _billController.cartShopping
        .where((element) => element.supplyPump != null)
        .toList();

    if (cartShopping.isEmpty) return totalQuantityFromCart;

    totalQuantityFromCart += cartShopping.length;

    return totalQuantityFromCart;
  }

  // retorna a quantidade de cada produto
  int getProductQuantityFromCart(Product product) {
    CartShoppingModel? cartShopping = _billController.cartShopping
        .where((element) =>
            element.productAndQuantity?.product?.codigo == product.codigo)
        .firstOrNull;

    if (cartShopping == null) return 0;

    return cartShopping.productAndQuantity!.quantity!;
  }

  // retorna o valor total do carrinho
  double getTotalValueFromCart() {
    double totalValue = 0.0;

    if (_billController.cartShopping.isEmpty) return totalValue;

    for (var item in _billController.cartShopping) {
      if (item.productAndQuantity != null) {
        totalValue += item.productAndQuantity!.product!.valor! *
            item.productAndQuantity!.quantity!;
      }

      if (item.supplyPump == null) continue;

      totalValue += item.supplyPump!.total ?? 0.0;
    }
    return totalValue;
  }

  CartShoppingModel? getCartByProduct(Product product) {
    return _billController.cartShopping
        .where(
          (element) =>
              element.productAndQuantity?.product?.codigo == product.codigo,
        )
        .firstOrNull;
  }

  CartShoppingModel? getCartBySupplyPump(SupplyPump supplyPump, {BillController? billController}) {
    if(billController != null) {
       return billController.cartShopping
        .where((element) => element.supplyPump?.id == supplyPump.id)
        .firstOrNull;
    }

    return _billController.cartShopping
        .where((element) => element.supplyPump?.id == supplyPump.id)
        .firstOrNull;
  }

  int getQuantityProductInCart() {
    int quantity = 0;

    if (_billController.cartShopping.isEmpty) return quantity;

    for (var item in _billController.cartShopping) {
      if (item.productAndQuantity != null) {
        quantity += 1;
      }
    }
    return quantity;
  }

  double getTotalToPay() {
    return getTotalValueFromCart() + 0.0 - 0.0;
  }

  
}
