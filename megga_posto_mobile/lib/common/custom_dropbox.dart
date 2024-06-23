// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/common/custom_text_style.dart';

class CustomDropbox<T> extends StatelessWidget {
  final Rx<T> value;
  final List<T> items;
  final double sizeDropbox;
  final Function(T) onChanged;
  final String Function(T) displayValue;

  const CustomDropbox({
    super.key,
    required this.value,
    required this.items,
    required this.sizeDropbox,
    required this.onChanged,
    required this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeDropbox,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() => DropdownButton<T>(
              icon: const Icon(Icons.arrow_drop_down),
              value: value.value, // Observe o valor
              items: items.map<DropdownMenuItem<T>>((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayValue(item),
                    style: CustomTextStyles.blackBoldStyle(20),
                  ),
                );
              }).toList(),
              onChanged: (T? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            )),
      ),
    );
  }
}
