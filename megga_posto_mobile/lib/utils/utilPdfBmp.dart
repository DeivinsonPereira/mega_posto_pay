// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';

class UtilPDF {
  // Função para converter uma string base64 em Uint8List
  static Uint8List convertBase64ToUint8List(String base64String) {
    return Uint8List.fromList(base64.decode(base64String));
  }

  static Uint8List convertStringToUint8List(String base64String) {
    return Uint8List.fromList(utf8.encode(base64String));
  }

  static String stringToBase64(String input) {
    var bytes = utf8.encode(input);
    var base64Str = base64.encode(bytes);
    return base64Str;
  }

  static String getTemporaryDirectoryPath() {
    return Directory.systemTemp.path;
  }

  static Future<String> salvarArquivoPDF(Uint8List arquivo) async {
    var name = '${Directory.systemTemp.path}/temp.pdf';
    final file = File(name);
    await file.writeAsBytes(arquivo);

    return name;
  }

  static Future<void> apagarArquivo(String arquivo) async {
    final file = File(arquivo);
    await file.delete();
  }

  static Future<String> pdfParaBMP(Uint8List arquivo,
      {double scale = 1}) async {
    var pathPDF = await salvarArquivoPDF(arquivo);
    String? imageCachedPath = await PdfBitmaps().pdfBitmap(
      params: PDFBitmapParams(
        pdfPath: pathPDF,
        pageInfo: BitmapConfigForPage(
          pageNumber: 1,
          scale: scale,
          backgroundColor: Colors.white,
        ),
        pdfRendererType: PdfRendererType.androidPdfRenderer,
      ),
    );
    return imageCachedPath ?? '';
  }

  static Future<Uint8List?> converterPDFparaBMP(String base64PDF) async {
    if (base64PDF != '') {
      String imageCachedPath = await UtilPDF.pdfParaBMP(
          UtilPDF.convertBase64ToUint8List(base64PDF),
          scale: 2.5);
      Uint8List? bytes = File(imageCachedPath).readAsBytesSync();
      UtilPDF.apagarArquivo(imageCachedPath);
      return bytes;
    }
    return null;
  }
}
