// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BuildLegend extends StatelessWidget {
  const BuildLegend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color colorText = const Color.fromARGB(255, 174, 174, 174);

    Widget _buildItemQuantity() {
      return Text(
        'Quantidade',
        style: TextStyle(color: colorText),
      );
    }

    Widget _buildItemName() {
      return Text(
        'Nome',
        style: TextStyle(color: colorText),
      );
    }

    Widget _buildIdProduct() {
      return Text(
        'Id',
        style: TextStyle(color: colorText),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildIdProduct(),
              const SizedBox(width: 20),
              _buildItemName(),
            ],
          ),
          _buildItemQuantity(),
        ],
      ),
    );
  }
}
