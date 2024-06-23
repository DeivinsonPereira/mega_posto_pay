import 'package:get/get.dart';
import '../model/cart_shopping_model.dart';
import '../model/collections/product.dart';
import '../model/supply_model.dart';

class BillController extends GetxController {
  late Supply supplySelected;

  bool isProduct = false;

  RxList<CartShoppingModel> cartShopping = <CartShoppingModel>[].obs;

  var products = <Product>[].obs;
}
