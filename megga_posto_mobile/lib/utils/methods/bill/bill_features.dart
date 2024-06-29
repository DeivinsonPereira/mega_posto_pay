import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/cart_shopping_model.dart';
import 'package:megga_posto_mobile/model/collections/product.dart';
import 'package:megga_posto_mobile/model/product_and_quantity_model.dart';
import 'package:megga_posto_mobile/model/supply_model.dart';

import 'package:megga_posto_mobile/model/supply_pump_model.dart';
import 'package:megga_posto_mobile/service/update_supply_pump.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_get.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../../repositories/isar_db/product/get_product.dart';

class BillFeatures {
  final _billController = Dependencies.billController();
  final _cameraPhotoController = Dependencies.cameraPhotoController();
  final _billGet = BillGet();
  final _paymentFeatures = PaymentFeatures();
  final _logger = SingletonsInstances().logger;

  BillFeatures._privateConstructor();

  static final BillFeatures _instance = BillFeatures._privateConstructor();

  factory BillFeatures() => _instance;

  Future<void> addProduct() async {
    List<Product> products = await GetProduct().getProduct();

    if (products.isNotEmpty) {
      _billController.products.assignAll(products);
    } else {
      _logger.e('Nenhum produto encontrado.');
      return;
    }
  }

  // adiciona os produtos se entrar na tela dos produtos diretamente
  void addCartShoppingListFromProduct(Product? product) {
    CartShoppingModel? cartShoppingWithProduct =
        _billGet.getCartByProduct(product!);

    if (cartShoppingWithProduct != null) {
      cartShoppingWithProduct.productAndQuantity!.quantity! + 1;
      _updateVariables();
      return;
    }

    ProductAndQuantityModel productAndQuantityModel =
        ProductAndQuantityModel(product: product, quantity: 1);

    _billController.cartShopping.add(CartShoppingModel(
        supplyPump: null, productAndQuantity: productAndQuantityModel));

    _updateVariables();
  }

  // Adiciona o abastecimento e os produtos no carrinho
  // caso já tenha um produto com o mesmo código no carrinho ele aumenta a quantidade,
  // se não ele adiciona o produto ao carrinho
  void addCartShoppingListFromSupply(
      {SupplyPump? supplyPump, Product? product}) {
    if (supplyPump != null) {
      CartShoppingModel? cartShopping =
          _billGet.getCartBySupplyPump(supplyPump);

      if (cartShopping == null) {
        _billController.cartShopping.add(CartShoppingModel(
            supplyPump: supplyPump, productAndQuantity: null));
        _updateVariables();
        return;
      }
    }

    if (product == null) return;

    CartShoppingModel? cartShoppingWithProduct =
        _billGet.getCartByProduct(product);

    if (cartShoppingWithProduct == null) {
      _billController.cartShopping.add(CartShoppingModel(
        supplyPump: null,
        productAndQuantity:
            ProductAndQuantityModel(product: product, quantity: 1),
      ));
      _updateVariables();
      return;
    }

    cartShoppingWithProduct.productAndQuantity = ProductAndQuantityModel(
      product: product,
      quantity: cartShoppingWithProduct.productAndQuantity!.quantity! + 1,
    );

    _updateVariables();
  }

  void setSupply(Supply supply) {
    _billController.supplySelected = supply;
    _updateVariables();
  }

  // limpa o carrinho de compras
  void clearCartShoppingList() {
    _billController.cartShopping.value = [];
  }

  // Limpa as variáveis
  void clearAll() {
    clearCartShoppingList();
    _updateVariables();
  }

  // remove um item do carrinho
  void removeItemCartShoppingList(
      {SupplyPump? supplyPump, Product? product, bool isCartShopping = false}) {
    if (product != null) {
      CartShoppingModel? cartShopping = _billGet.getCartByProduct(product);

      if (cartShopping == null) return;

      if (cartShopping.productAndQuantity!.quantity! > 1) {
        cartShopping.productAndQuantity = ProductAndQuantityModel(
          product: product,
          quantity: cartShopping.productAndQuantity!.quantity! - 1,
        );
        _updateVariables();
        return;
      }

      _billController.cartShopping.remove(cartShopping);

      if (isCartShopping) {
        if (_billController.cartShopping.isEmpty) {
          _cameraPhotoController.clearCamera();
          Get.back();
        }
      }
      _updateVariables();
      return;
    }

    if (supplyPump == null) return;
    CartShoppingModel? cartShopping = _billGet.getCartBySupplyPump(supplyPump);

    if (cartShopping == null) return;

    _billController.cartShopping.remove(cartShopping);

    if (isCartShopping) {
      if (_billController.cartShopping.isEmpty) {
        Get.back();
        _paymentFeatures.clearAll();
        _cameraPhotoController.clearCamera();
      }
    }
    _updateVariables();
  }

  void _updateVariables() {
    _billController.update();
    _billController.cartShopping.refresh();
  }
}
