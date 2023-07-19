import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class LiveCameraPreview extends StatefulWidget {
  const LiveCameraPreview({
    super.key,
    required this.camera,
    required this.onImage,
  });

  final CameraDescription camera;
  final Function(InputImage inputImage) onImage;

  @override
  State<LiveCameraPreview> createState() => _LiveCameraPreviewState();
}

class _LiveCameraPreviewState extends State<LiveCameraPreview> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();

    _startLiveFeed();
  }

  @override
  void dispose() {
    super.dispose();

    _stopLiveFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(child: CameraPreview(_controller!)),
    );
  }

  Future _startLiveFeed() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller?.initialize().then((_) {
      if (!mounted) return;

      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation =
        InputImageRotationValue.fromRawValue(widget.camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
