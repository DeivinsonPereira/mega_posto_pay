import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_elevated_button.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/controller/camera_controller.dart';
import 'package:megga_posto_mobile/page/payment/components/page/signatures/logic/logic_buttons_camera.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _cameraPhotoController = Dependencies.cameraPhotoController();

    Widget _buttonCapture(CameraPhotoController _) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
            onPressed: () async {
              await _.takePicture();
            },
          ),
        ),
      );
    }

    Widget _buildButtonFinalize(CameraPhotoController _) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: CustomElevatedButton(
                  text: 'Finalizar',
                  textStyle: CustomTextStyles.whiteBoldStyle(20),
                  function: () async {
                    LogicButtonsCamera().continueButton();
                  },
                  radious: 0,
                  colorButton: CustomColors.confirmButton),
            ),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              LogicButtonsCamera().backButton();
            },
          ),
          title: const Text('Camera'),
        ),
        body: GetBuilder<CameraPhotoController>(
          builder: (_) {
            if (_.cameras == null || _.cameras!.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!_.cameraController.value.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              width: Get.size.width,
              child: Column(
                children: [
                  if (_.imageFile.value == null)
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              SizedBox(
                                  width: Get.size.width,
                                  child: CameraPreview(_.cameraController)),
                              _buttonCapture(_),
                            ],
                          )),
                        ],
                      ),
                    ),
                  if (_.imageFile.value != null)
                    Expanded(
                      child: Row(
                        children: [
                          Image.file(
                              File(
                                _.imageFile.value!.path,
                              ),
                              width: Get.size.width,
                              height: Get.size.height * 0.83),
                        ],
                      ),
                    ),
                  if (_cameraPhotoController.imageFile.value != null)
                    _buildButtonFinalize(_)
                ],
              ),
            );
          },
        ));
  }
}
