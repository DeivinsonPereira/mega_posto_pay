// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/model/list_reimpressao.dart';

import 'package:megga_posto_mobile/page/management/pages/components/header_dialogs.dart';
import 'package:megga_posto_mobile/page/management/pages/report/components/build_card_vendas_reimpressao.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import 'components/custom_line_buttons_management.dart';

class ReprintSellPage extends StatelessWidget {
  final String textHeader;
  final Function() function;
  const ReprintSellPage({
    Key? key,
    required this.textHeader,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final _managementController = Dependencies.managementController();

    Widget _buildHeader() {
      return HeaderDialogs(title: textHeader);
    }

    Widget _buildContent() {
      return ListView.builder(
          itemCount: _managementController.listReimpressao.length,
          itemBuilder: (context, index) {
            ListReimpressao listReimpressao =
                _managementController.listReimpressao[index];
            return BuildCardVendasReimpressao(
                index: index, listReimpressao: listReimpressao);
          });
    }

    Widget _buildLineButtons() {
      return CustomLineButtonsManagement(function: function);
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }
}
