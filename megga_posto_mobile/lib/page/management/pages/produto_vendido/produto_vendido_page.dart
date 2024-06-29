// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/page/management/pages/components/header_dialogs.dart';
import 'package:megga_posto_mobile/page/management/pages/produto_vendido/build_card_produto_vendido.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

import '../../../../model/produto_vendido_model.dart';
import '../components/custom_buttons_dialog.dart';

class ProdutoVendidoPage extends StatelessWidget {
  final Function() function;
  const ProdutoVendidoPage({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customButtons = CustomButtonsDialog.instance;
    final _managementController = Dependencies.managementController();

    Widget _buildHeader() {
      return const HeaderDialogs(title: 'Produtos Vendidos');
    }

    Widget _buildContent() {
      return ListView.builder(
        itemCount: _managementController.listProdutosVendidos.length,
        itemBuilder: (context, index) {
          ProdutoVendidoModel produtoVendido =
              _managementController.listProdutosVendidos[index];
          return BuildCardProdutoVendido(
            produtoVendidoSelected: produtoVendido,
          );
        },
      );
    }

    Widget _buildButtonBack() {
      return _customButtons.buildButton(
          'VOLTAR', CustomColors.backButton, () => Get.back());
    }

    Widget _buildContinue() {
      return _customButtons.buildButton(
          'IMPRIMIR', CustomColors.confirmButton, () => function());
    }

    Widget _buildLineButtons() {
      return Row(
        children: [
          Expanded(child: _buildButtonBack()),
          Expanded(child: _buildContinue()),
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
