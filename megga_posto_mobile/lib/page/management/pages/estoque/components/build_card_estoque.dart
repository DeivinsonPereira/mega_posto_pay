// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/model/estoque_produto.dart';

class BuildCardEstoque extends StatelessWidget {
  final EstoqueProduto estoqueProdutoSelected;
  const BuildCardEstoque({
    Key? key,
    required this.estoqueProdutoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildItemQuantity() {
      return SizedBox(
          width: Get.size.width * 0.1,
          child:
              Text(estoqueProdutoSelected.estoqueQuantidadeFisico.toString()));
    }

    Widget _buildItemName() {
      return Text(estoqueProdutoSelected.nomeProduto);
    }

    Widget _buildIdProduct() {
      return SizedBox(
          width: Get.size.width * 0.2,
          child: Text(estoqueProdutoSelected.idProduto.toString()));
    }

    Widget _buildLineItem() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIdProduct(),
          Expanded(child: _buildItemName()),
          _buildItemQuantity(),
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
