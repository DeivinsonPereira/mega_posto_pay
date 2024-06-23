// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_back_button.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/controller/bill_controller.dart';
import 'package:megga_posto_mobile/page/supply_pump/logic/logic_navigation_next_page.dart';


import '../../common/custom_header_app_bar.dart';
import '../../utils/static/custom_colors.dart';
import '../../model/supply_model.dart';
import '../../utils/dependencies.dart';
import 'components/custom_card_supply_pump.dart';

class SupplyPumpPage extends StatelessWidget {
  final Supply supplySelected;
  const SupplyPumpPage({
    Key? key,
    required this.supplySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _billController = Dependencies.billController();
    var supplyController = Dependencies.supplyController();

    // Constrói a listview e chama os cards
    Widget _buildListView() {
      return GetBuilder<BillController>(
        builder: (_) {
          return ListView.builder(
              itemCount: supplyController.supplySelectedPumpList.length,
              itemBuilder: (context, index) {
                var supplyPumpSelected =
                    supplyController.supplySelectedPumpList[index];
                return CustomCardSupplyPump(
                    supplyPumpSelected: supplyPumpSelected,
                    index: index,
                    supplySelected: supplySelected,
                    controller: _billController);
              });
        },
      );
    }

    Widget _buildButtonBack() {
      return CustomBackButton(text: 'Voltar', function: () => Get.back());
    }

    Widget _buildButtonContinue() {
      return CustomContinueButton(
          text: 'Continuar',
          function: () => LogicNavigationNextPage()
              .nextPage(_billController.supplySelected));
    }

    Widget _buildLineButtons() {
      return Row(
        children: [
          Expanded(child: _buildButtonBack()),
          Expanded(child: _buildButtonContinue()),
        ],
      );
    }

    // Constrói o corpo da page
    Widget _buildBody() {
      return Column(
        children: [
          CustomHeaderAppBar(
            isSupplyPump: true,
            bicoId: supplySelected.bicoId,
          ),
          Expanded(child: _buildListView()),
          _buildLineButtons(),
        ],
      );
    }

    // Constrói o Scaffold
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: _buildBody(),
    );
  }
}
