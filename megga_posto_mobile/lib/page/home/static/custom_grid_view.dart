import 'package:flutter/material.dart';

import '../logic/logic_navigation_home_page.dart';

class CustomGridView {
  static final LogicNavigationHomePage _logicNavigation =
      LogicNavigationHomePage();

  static const List<Color> colorsGridView = [
    Color(0xFF0C6794),
    Color(0xFF005C53),
    Color.fromARGB(255, 224, 149, 19),
  ];

  static const List<IconData> iconsGridView = [
    Icons.local_gas_station_rounded,
    Icons.shopping_cart_outlined,
    Icons.list,
  ];

  static List<Text> titlesGridView = [
    Text('Abastecimento', style: _titleStyle()),
    Text('Produtos', style: _titleStyle()),
    Text(
      'Gerenciamento',
      style: _titleStyle(),
    )
  ];

  static List<Function()> functionsGridView = [
    () => _logicNavigation.navigationToSupply(),
    () => _logicNavigation.navigationToProduct(),
    () => _logicNavigation.navigationToManagement()
  ];

  static TextStyle _titleStyle() {
    return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  }
}
