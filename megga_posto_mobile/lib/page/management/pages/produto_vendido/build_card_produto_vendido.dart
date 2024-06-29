// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:megga_posto_mobile/model/produto_vendido_model.dart';

import '../../../../utils/format_numbers.dart';

class BuildCardProdutoVendido extends StatelessWidget {
  final ProdutoVendidoModel produtoVendidoSelected;
  const BuildCardProdutoVendido({
    Key? key,
    required this.produtoVendidoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildItemName() {
      return Text(produtoVendidoSelected.nome ?? '');
    }

    Widget _buildIdProduct() {
      return SizedBox(
          child:
              Text('Código: ${(produtoVendidoSelected.codigo.toString())}'));
    }

    Widget _buildItemQuantity() {
      return SizedBox(
          child: Text(
              'Quantidade: ${(produtoVendidoSelected.quantidade.toString())}'));
    }

    Widget _buildValue() {
      return Text(
          'Valor: R\$ ${FormatNumbers.formatNumbertoString(produtoVendidoSelected.total ?? 0.0)}');
    }

    Widget _buildLineItem() {
      return Column(
        children: [
          Row(
            children: [
              _buildIdProduct(),
              const SizedBox(width: 15),
              _buildItemName(),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildItemQuantity(),
              const SizedBox(width: 15),
              _buildValue(),
            ],
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: _buildLineItem(),
      ),
    );
  }
}
