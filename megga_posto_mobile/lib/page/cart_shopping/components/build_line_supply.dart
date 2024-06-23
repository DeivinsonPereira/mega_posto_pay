// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/model/supply_pump_model.dart';
import 'package:megga_posto_mobile/utils/format_string.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_features.dart';

import '../../../common/custom_text_style.dart';
import '../../../utils/dependencies.dart';
import '../../../utils/format_numbers.dart';

class BuildLineSupply extends StatelessWidget {
  final SupplyPump supplyPumpSelected;
  const BuildLineSupply({
    Key? key,
    required this.supplyPumpSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _billController = Dependencies.billController();
    var _billFeatures = BillFeatures();

    Widget _buildDeleteIcon(SupplyPump supplyPumpSelected) {
      return IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () => _billFeatures.removeItemCartShoppingList(
            supplyPump: supplyPumpSelected, isCartShopping: true),
      );
    }

    // Constrói o nome do abastecimento no carrinho
    Widget _buildNameSupply(SupplyPump supplyPumpSelected) {
      return SizedBox(
        width: Get.size.width * 0.37,
        child: Text(
          FormatString.maxLengthText(
              _billController.supplySelected.descricaoBico, 25),
          style: CustomTextStyles.whiteStyle(15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Constrói a quantidade do abastecimento no carrinho
    Widget _buildQuantitySupply(SupplyPump supplyPumpSelected) {
      return SizedBox(
        width: Get.size.width * 0.17,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            supplyPumpSelected.quantidade!.toStringAsFixed(3),
            style: CustomTextStyles.whiteStyle(14),
          ),
        ),
      );
    }

    // Constrói o valor do abastecimento no carrinho
    Widget _buildTotalSupply(SupplyPump supplyPumpSelected) {
      return SizedBox(
        width: Get.size.width * 0.32,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'R\$${FormatNumbers.formatNumbertoString(supplyPumpSelected.total)}',
            style: CustomTextStyles.whiteBoldStyle(14),
          ),
        ),
      );
    }

    return SizedBox(
      height: Get.size.height * 0.07,
      child: Row(
        children: [
          _buildDeleteIcon(supplyPumpSelected),
          _buildNameSupply(supplyPumpSelected),
          _buildQuantitySupply(supplyPumpSelected),
          _buildTotalSupply(supplyPumpSelected),
        ],
      ),
    );
  }
}
