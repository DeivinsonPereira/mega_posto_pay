// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';

import 'package:megga_posto_mobile/model/list_reimpressao.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';

import '../../../../../controller/management_controller.dart';

class BuildCardVendasReimpressao extends StatelessWidget {
  final int index;
  final ListReimpressao listReimpressao;
  const BuildCardVendasReimpressao({
    Key? key,
    required this.index,
    required this.listReimpressao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dependencies.managementController();
    final _managerFeatures = ManagementFeatures.instance;

    Widget _buildIdNf() {
      return Text(
        'ID NF: ${listReimpressao.idnf}',
        style: CustomTextStyles.blackStyle(16),
      );
    }

    Widget _buildDataEmissao() {
      return Text('Data Emissão: ${listReimpressao.emissao}');
    }

    Widget _buildNomeCliente() {
      return listReimpressao.nomeCliente == ''
          ? const Text('Nome Cliente: Sem Nome')
          : Text('Nome Cliente: ${listReimpressao.nomeCliente}');
    }

    Widget _buildNFSIdCaixa() {
      return Text('Id caixa: ${listReimpressao.nfsIdcaixa}');
    }

    Widget _buildNomeUsuario() {
      return Text('Usuario: ${listReimpressao.nomeUsuario}');
    }

    Widget _buildValue() {
      return Text(
          'Valor: R\$ ${FormatNumbers.formatNumbertoString(listReimpressao.valor)}');
    }

    Widget _buildNFCENumber() {
      return Text('NFCe: ${listReimpressao.noNfce}');
    }

    Widget _buildSerie() {
      return Text('Serie: ${listReimpressao.serie}');
    }

    Widget _buildBody() {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIdNf(),
                _buildDataEmissao(),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                _buildNomeCliente(),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNFSIdCaixa(),
                _buildNomeUsuario(),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNFCENumber(),
                _buildSerie(),
                _buildValue(),
              ],
            )
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => _managerFeatures.updateidReimpressaoSelected(index),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GetBuilder<ManagementController>(
          builder: (_) => Material(
            color: _.idReimpressaoSelected.value == index
                ? const Color.fromARGB(255, 129, 185, 231)
                : Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
