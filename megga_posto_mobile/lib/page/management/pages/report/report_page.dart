// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/model/resumo_financeiro.dart';
import 'package:megga_posto_mobile/page/management/pages/report/components/custom_line_buttons_management.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_get.dart';

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

    Widget _buildName(ResumoFinanceiro resumoFinanceiro) {
      return Text(
        resumoFinanceiro.nome ?? '',
        style: CustomTextStyles.blackStyle(16),
      );
    }

    Widget _buildValue(ResumoFinanceiro resumoFinanceiro) {
      return Text(
        'R\$ ${FormatNumbers.formatNumbertoString(resumoFinanceiro.valor)}',
        style: CustomTextStyles.blackStyle(16),
      );
    }

    Widget _buildCardResumoFinanceiro(ResumoFinanceiro resumoFinanceiro) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildName(resumoFinanceiro),
                _buildValue(resumoFinanceiro),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      );
    }

    Widget _buildContent() {
      return ListView.builder(
          itemCount: _managementController.listResumoFinanceiro.length,
          itemBuilder: (context, index) {
            ResumoFinanceiro resumoFinanceiro =
                _managementController.listResumoFinanceiro[index];
            return _buildCardResumoFinanceiro(resumoFinanceiro);
          });
    }

    Widget _buildTotal() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ',
              style: CustomTextStyles.blackBoldStyle(16),
            ),
            Text(
              'R\$ ${FormatNumbers.formatNumbertoString(ManagementGet.instance.getTotalValue())}',
              style: CustomTextStyles.blackBoldStyle(16),
            ),
          ],
        ),
      );
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
          _buildTotal(),
          const SizedBox(height: 10),
          _buildLineButtons(),
        ],
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 5,
      child: SizedBox(
        height: Get.size.height * 0.6,
        width: Get.size.width * 0.9,
        child: _buildBody(),
      ),
    );
  }
}
