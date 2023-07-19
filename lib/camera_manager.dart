import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraManager extends GetxController {
  CameraManager({required this.camera});

  final CameraDescription camera;
}
