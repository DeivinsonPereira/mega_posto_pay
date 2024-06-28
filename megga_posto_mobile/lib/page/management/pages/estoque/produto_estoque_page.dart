// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/model/estoque_produto.dart';
import 'package:megga_posto_mobile/page/management/pages/components/custom_buttons_dialog.dart';
import 'package:megga_posto_mobile/page/management/pages/components/header_dialogs.dart';
import 'package:megga_posto_mobile/page/management/pages/estoque/components/build_card_estoque.dart';
import 'package:megga_posto_mobile/page/management/pages/estoque/components/build_legend.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import '../../../../utils/static/custom_colors.dart';

class ProdutoEstoquePage extends StatelessWidget {
  final Function() function;
  const ProdutoEstoquePage({
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

    Widget _buildLegend() {
      return const BuildLegend();
    }

    Widget _buildDivider() {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Divider(),
      );
    }

    Widget _buildContent() {
      return ListView.builder(
        itemCount: _managementController.listEstoque.length,
        itemBuilder: (context, index) {
          EstoqueProduto estoqueProduto =
              _managementController.listEstoque[index];
          return BuildCardEstoque(
            estoqueProdutoSelected: estoqueProduto,
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
          _buildLegend(),
          _buildDivider(),
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
