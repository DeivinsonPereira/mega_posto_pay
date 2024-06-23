import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/model/management_model.dart';
import 'package:megga_posto_mobile/page/management/dialogs/cash_moviment/cash_moviment_dialog.dart';
import 'package:megga_posto_mobile/page/management/dialogs/report/report_dialog.dart';

class ListIconsManagement {
  ListIconsManagement._privateConstructor();

  static ListIconsManagement instance =
      ListIconsManagement._privateConstructor();

  List<ManagementModel> listToCard = [
    ManagementModel(
      color: const Color(0xFFC89A59),
      icon: Icons.money_off,
      title: Text('Sangria', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () {
        // TODO - fazer a busca do saldo total
        Get.dialog(
          barrierDismissible: false,
          CashMovimentDialog(
              function: () {
                //TODO - fazer o salvamento
              },
              textHeader: 'SANGRIA - PISTA'),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 6, 116, 116),
      icon: Icons.attach_money,
      title: Text('Suprimento', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () {
        // TODO - fazer a busca do saldo total
        Get.dialog(
          barrierDismissible: false,
          CashMovimentDialog(
              function: () {
                //Todo fazer o salvamento
              },
              textHeader: 'SUPRIMENTO - PISTA'),
        );
      },
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 13, 93, 150),
      icon: Icons.insert_chart_outlined,
      title: Text('Relatório', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () =>
          //TODO - fazer a busca do relatório
          Get.dialog(
        barrierDismissible: false,
        ReportDialog(
          textHeader: 'RELATÓRIO DO CAIXA',
          function: () {
            //TODO - Fazer a impressão
          },
        ),
      ),
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 122, 52, 5),
      icon: FontAwesomeIcons.moneyBillTrendUp,
      title: Text('Vendas', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () =>
          //TODO - fazer a busca do relatório
          Get.dialog(
        barrierDismissible: false,
        ReportDialog(
          textHeader: 'PRODUTOS VENDIDOS',
          function: () {
            //TODO - Fazer a impressão
          },
        ),
      ),
    ),
    ManagementModel(
      color: const Color.fromARGB(255, 77, 101, 3),
      icon: FontAwesomeIcons.layerGroup,
      title: Text('Estoque', style: CustomTextStyles.whiteBoldStyle(14)),
      function: () =>
          //TODO - fazer a busca do relatório
          Get.dialog(
        barrierDismissible: false,
        ReportDialog(
          textHeader: 'ESTOQUE DE PRODUTO',
          function: () {
            //TODO - Fazer a impressão
          },
        ),
      ),
    ),
  ];
}
