// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/list_cancelamento_model.dart';
import 'package:megga_posto_mobile/page/management/pages/cancelamento/build_card_cancelamento.dart';

import 'package:megga_posto_mobile/page/management/pages/components/header_dialogs.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import '../../../../utils/static/custom_colors.dart';
import '../components/custom_buttons_dialog.dart';

class CancelamentoPage extends StatelessWidget {
  final Function() function;
  const CancelamentoPage({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customButtons = CustomButtonsDialog.instance;
    final _managementController = Dependencies.managementController();

    Widget _buildHeader() {
      return const HeaderDialogs(title: 'Estoque de Produtos');
    }

    Widget _buildContent() {
      return ListView.builder(
        itemCount: _managementController.listCancelamento.length,
        itemBuilder: (context, index) {
          ListCancelamentoModel cancelamentoSelected =
              _managementController.listCancelamento[index];
          return BuildCardCancelamento(
            cancelamentoSelected: cancelamentoSelected,
            index: index,
          );
        },
      );
    }

    Widget _buildButtonBack() {
      return _customButtons.buildButton('VOLTAR', CustomColors.backButton, () {
        _managementController.motivoController.text = '';
        _managementController.idCancelamentoSelected.value = -1;
        Get.back();
      });
    }

    Widget _buildCancelar() {
      return _customButtons.buildButton(
          'CANCELAR', CustomColors.containerQuantity, () => function());
    }

    Widget _buildLineButtons() {
      return Row(
        children: [
          Expanded(child: _buildButtonBack()),
          Expanded(child: _buildCancelar()),
        ],
      );
    }

    Widget _buildBody() {
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildLineButtons(),
        ],
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SizedBox(
        height: Get.size.height * 0.8,
        width: Get.size.width * 0.9,
        child: _buildBody(),
      ),
    );
  }
}
