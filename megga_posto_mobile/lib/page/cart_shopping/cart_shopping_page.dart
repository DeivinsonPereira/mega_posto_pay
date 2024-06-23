// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/container_total/custom_container_total.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_app_bar.dart';
import 'package:megga_posto_mobile/controller/bill_controller.dart';
import 'package:megga_posto_mobile/model/cart_shopping_model.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';
import 'package:megga_posto_mobile/page/cart_shopping/components/build_line_legend.dart';
import 'package:megga_posto_mobile/page/payment/payment_page.dart';

import '../../common/custom_back_button.dart';
import 'components/build_line_products.dart';
import 'components/build_line_supply.dart';

class CartShoppingPage extends StatelessWidget {
  const CartShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dependencies.billController();

    Widget _buildListView() {
      return GetBuilder<BillController>(
        builder: (_) {
          return ListView.builder(
            itemCount: _.cartShopping.length,
            itemBuilder: (context, index) {
              CartShoppingModel cartShoppingSelected = _.cartShopping[index];
              if (cartShoppingSelected.supplyPump != null) {
                return BuildLineSupply(
                    supplyPumpSelected: cartShoppingSelected.supplyPump!);
              }

              return BuildLineProducts(
                  productAndQuantity: cartShoppingSelected.productAndQuantity!);
            },
          );
        },
      );
    }

    // Constrói os botões de continuar e voltar
    Widget _buildButtons() {
      return Row(
        children: [
          Expanded(
            child: CustomBackButton(
              function: () {
                Get.back();
              },
              text: 'Voltar',
            ),
          ),
          Expanded(
            child: CustomContinueButton(
              text: 'Seguir',
              function: () => Get.to(
                () => const PaymentPage(),
              ),
            ),
          )
        ],
      );
    }

    // Constrói o corpo da página
    Widget _buildBody() {
      return SizedBox(
        width: Get.size.width,
        height: Get.size.height,
        child: Column(children: [
          CustomHeaderAppBar(),
          const BuildLineLegend(),
          Expanded(child: _buildListView()),
          const CustomContainerTotal(),
          _buildButtons(),
        ]),
      );
    }

    // Constrói a page
    return Scaffold(
        backgroundColor: CustomColors.backgroundCartShopping,
        body: _buildBody());
  }
}
