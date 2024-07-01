import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraPhotoController extends GetxController {
  late CameraController _cameraController;
  List<CameraDescription>? cameras;
  Rx<XFile?> imageFile = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        _cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController.initialize();
        update();
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      return;
    }
    try {
      imageFile.value = await _cameraController.takePicture();
      update();
    } catch (e) {
      print(e);
    }
  }

  //Limpar camera
  Future<void> clearCamera() async {
    if (Get.isRegistered<CameraPhotoController>()) {
      imageFile.value = null;
      update();
    }
  }

  @override
  void onClose() {
    _cameraController.dispose();
    super.onClose();
  }

  CameraController get cameraController => _cameraController;
}
