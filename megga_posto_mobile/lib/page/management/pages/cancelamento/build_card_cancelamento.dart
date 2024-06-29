// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/controller/management_controller.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';

import '../../../../model/list_cancelamento_model.dart';

class BuildCardCancelamento extends StatelessWidget {
  final ListCancelamentoModel cancelamentoSelected;
  final int index;
  const BuildCardCancelamento({
    Key? key,
    required this.cancelamentoSelected,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _managementFeatures = ManagementFeatures.instance;
    Dependencies.managementController();

    Widget _buildClientName() {
      return Text('Nome Cliente: ${cancelamentoSelected.nomeCliente}');
    }

    Widget _buildIdNfce() {
      return Text('Id NFCe: ${(cancelamentoSelected.nfsIdcaixa.toString())}');
    }

    Widget _buildNoNfce() {
      return Text('Nº NFCe: ${(cancelamentoSelected.noNfce.toString())}');
    }

    Widget _buildSerie() {
      return Text(
        'Serie: ${(cancelamentoSelected.serie.toString())}',
      );
    }

    Widget _buildValue() {
      return Text(
          'Valor: R\$ ${FormatNumbers.formatNumbertoString(cancelamentoSelected.valor ?? 0.0)}');
    }

    Widget _buildLineItem() {
      return Column(
        children: [
          Row(
            children: [
              _buildClientName(),
              const SizedBox(width: 5),
            ],
          ),
          Row(
            children: [
              _buildIdNfce(),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildNoNfce(),
              const SizedBox(width: 15),
              _buildSerie(),
              const SizedBox(width: 15),
              _buildValue(),
            ],
          )
        ],
      );
    }

    return InkWell(
      onTap: () => _managementFeatures.updateIdCancelamentoSelected(index),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GetBuilder<ManagementController>(
          builder: (_) {
            return Material(
              color: _.idCancelamentoSelected.value == index
                  ? const Color.fromARGB(255, 117, 196, 236)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildLineItem(),
              ),
            );
          },
        ),
      ),
    );
  }
}
