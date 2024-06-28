// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';
import 'package:megga_posto_mobile/page/management/pages/report/components/custom_line_buttons_management.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

class ReportPage extends StatelessWidget {
  final Function() function;
  const ReportPage({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _managementController = Dependencies.managementController();

    Widget _buildHeader() {
      return const CustomHeaderDialog(
        text: "Resumo Financeiro",
      );
    }

    Widget _buildContent() {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {});
    }

    Widget _buildLineButtons() {
      return CustomLineButtonsManagement(
        function: function,
      );
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

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 5,
      child: SizedBox(
        height: Get.size.height * 0.8,
        width: Get.size.width * 0.8,
        child: _buildBody(),
      ),
    );
  }
}
