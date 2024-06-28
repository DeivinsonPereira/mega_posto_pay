import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/model/management_model.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/page/management/logic/logic_buttons_management.dart';
import 'package:megga_posto_mobile/page/management/pages/cash_moviment/cash_moviment_page.dart';
import 'package:megga_posto_mobile/page/management/pages/report/report_page.dart';
import 'package:megga_posto_mobile/page/management/pages/report/reprint_sell_page.dart';
import 'package:megga_posto_mobile/repositories/http/seach_estoque_produto.dart';
import 'package:megga_posto_mobile/repositories/http/search_reimpressao_list.dart';
import 'package:megga_posto_mobile/service/print/print_management.dart';
import 'package:megga_posto_mobile/service/register_moviment/record_cash_withdrawal.dart';
import 'package:megga_posto_mobile/service/register_moviment/record_expense.dart';
import 'package:megga_posto_mobile/service/register_moviment/record_salary_advance.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';

import '../../../service/register_moviment/return_resumo_financeiro.dart';
import '../pages/estoque/produto_estoque_page.dart';

class ListIconsManagement {
  List<ManagementModel> listToCard = [
    ManagementModel(
      color: const Color(0xFFC89A59),
      icon: Icons.money_off,
      title: Text('Sangria', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () {
        Get.to(
          () => CashMovimentPage(
              function: () async {
                LogicButtonsManagement.instance
                    .printAndSendWithdrawal(() async {
                  Get.dialog(const LoadingPage());
                  await RecordCashWithdrawal().record();
                  await PrintManagement().withdrawalPrint('SANGRIA').then(
                      (element) => ManagementFeatures.instance.resetValues());
                });
              },
              textHeader: 'SANGRIA - PISTA'),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 77, 101, 3),
      icon: FontAwesomeIcons.layerGroup,
      title: Text('Despesa', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () async {
        Get.dialog(
            barrierDismissible: false,
            CashMovimentPage(
              textHeader: 'DESPESA',
              function: () async {
                LogicButtonsManagement.instance
                    .printAndSendWithdrawal(() async {
                  Get.dialog(const LoadingPage());
                  await RecordExpense().record();
                  await PrintManagement().withdrawalPrint('DESPESA').then(
                      (element) => ManagementFeatures.instance.resetValues());
                });
              },
            ));
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 3, 18, 101),
      icon: FontAwesomeIcons.layerGroup,
      title: Text('Vale', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () async {
        Get.dialog(
          barrierDismissible: false,
          CashMovimentPage(
            textHeader: 'VALE',
            function: () async {
              LogicButtonsManagement.instance.printAndSendWithdrawal(() async {
                Get.dialog(const LoadingPage());
                await RecordSalaryAdvance().record();
                await PrintManagement().withdrawalPrint('VALE').then(
                    (element) => ManagementFeatures.instance.resetValues());
              });
            },
          ),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 6, 116, 116),
      icon: Icons.attach_money,
      title: Text('Suprimento', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () {
        Get.to(
          () => CashMovimentPage(
            function: () async {
              // Get.dialog(const LoadingPage());
              // await RecordCashSupply().record();
              await PrintManagement()
                  .supplyCash()
                  .then((element) => ManagementFeatures.instance.resetValues());
            },
            textHeader: 'SUPRIMENTO - PISTA',
            isSupplyCash: true,
          ),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 122, 52, 5),
      icon: FontAwesomeIcons.moneyBillTrendUp,
      title: Text('Vendas', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () async {
        Get.dialog(const LoadingPage());
        await SearchReimpressaoList.instance.search();
        Get.back();

        Get.to(
          () => ReprintSellPage(
            textHeader: 'VENDAS',
            function: () {
              PrintManagement().reprintCupom();
            },
          ),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 77, 2, 92),
      icon: FontAwesomeIcons.layerGroup,
      title: Text('Estoque', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () async {
        Get.dialog(const LoadingPage());
        await SeachEstoqueProduto.instance.search();
        Get.back();

        Get.dialog(
          barrierDismissible: false,
          ProdutoEstoquePage(
            function: () {
              PrintManagement().printStock();
            },
          ),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 101, 3, 19),
      icon: FontAwesomeIcons.layerGroup,
      title: Text('Resumo Fin.', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () async {
        final _managementController = Dependencies.managementController();
        Get.dialog(const LoadingPage());
        await ReturnResumoFinanceiro().returnResumoFinanceiro();
        Get.back();
        if (_managementController.listResumoFinanceiro.isNotEmpty) {
          Get.dialog(
            barrierDismissible: false,
            ReportPage(
              function: () {
                PrintManagement().relatorio();
              },
            ),
          );
        }
      },
    ),
  ];
}
