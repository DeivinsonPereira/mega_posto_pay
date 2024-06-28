import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/common/custom_header_app_bar.dart';
import 'package:megga_posto_mobile/common/custom_text_assignature.dart';
import 'package:megga_posto_mobile/page/management/static/list_icons_management.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

import '../home/components/custom_card_home_page.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _listIconsManagement = ListIconsManagement();

    // Constrói os Cards
    Widget _buildCard(int index) {
      return CustomCardHomePage(
        color: _listIconsManagement.listToCard[index].color,
        icon: _listIconsManagement.listToCard[index].icon,
        title: _listIconsManagement.listToCard[index].title,
        function: _listIconsManagement.listToCard[index].function,
        isManagement: true,
      );
    }

    // Constrói o body
    Widget _buildBody() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: _listIconsManagement.listToCard.length,
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      );
    }

    Widget _buildAssignation() {
      return const CustomTextAssignature();
    }

    Widget _buildHeader() {
      return CustomHeaderAppBar();
    }

    // Constrói a página
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildBody(),
          ),
          _buildAssignation(),
        ],
      ),
    );
  }
}
