// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/model/product_and_quantity_model.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_features.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

import '../../../common/custom_text_style.dart';
import '../../../utils/format_numbers.dart';
import '../../../utils/format_string.dart';

class BuildLineProducts extends StatelessWidget {
  final ProductAndQuantityModel productAndQuantity;
  const BuildLineProducts({
    Key? key,
    required this.productAndQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _billFeatures = BillFeatures();
    const double sizeButton = 25;

    // Constrói o nome do produto no carrinho
    Widget _buildNameProduct(ProductAndQuantityModel productAndQuanity) {
      return SizedBox(
        width: Get.size.width * 0.4,
        child: Text(
          FormatString.maxLengthText(productAndQuanity.product!.descricao!, 17),
          style: CustomTextStyles.whiteStyle(16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    Widget _buildIcons(Color color, IconData icon, Function() function) {
      return InkWell(
        onTap: function,
        child: Container(
          width: sizeButton,
          height: sizeButton,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      );
    }

    Widget _buildButtonAddProduct() {
      return _buildIcons(
          CustomColors.confirmButton,
          Icons.add,
          () => _billFeatures.addCartShoppingListFromSupply(
              product: productAndQuantity.product));
    }

    Widget _buildTextQuantity() {
      return Text(
        productAndQuantity.quantity.toString(),
        style: CustomTextStyles.whiteStyle(16),
      );
    }

    Widget _buildButtonRemoveProduct() {
      return _buildIcons(
          const Color.fromARGB(255, 122, 31, 24),
          Icons.remove,
          () => _billFeatures.removeItemCartShoppingList(
              product: productAndQuantity.product, isCartShopping: true));
    }

    // Constrói a quantidade do produto no carrinho
    Widget _buildQuantityProduct(ProductAndQuantityModel productAndQuanity) {
      return SizedBox(
        width: Get.size.width * 0.26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildButtonAddProduct(),
            const SizedBox(width: 5),
            _buildTextQuantity(),
            const SizedBox(width: 5),
            _buildButtonRemoveProduct(),
          ],
        ),
      );
    }

    // Constrói o valor total do produto no carrinho
    Widget _buildTotalProduct(ProductAndQuantityModel productAndQuanity) {
      return SizedBox(
        width: Get.size.width * 0.28,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'R\$${FormatNumbers.formatNumbertoString(productAndQuanity.product!.valor! * productAndQuanity.quantity!)}',
            style: CustomTextStyles.whiteBoldStyle(16),
          ),
        ),
      );
    }

    return SizedBox(
      height: Get.size.height * 0.05,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                _buildNameProduct(productAndQuantity),
                _buildQuantityProduct(productAndQuantity),
                _buildTotalProduct(productAndQuantity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
