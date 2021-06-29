import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'barcode_scanner_status.dart';

class BarcodeScannerController {
  BarcodeScannerStatus status = BarcodeScannerStatus();
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  void getAvailableCameras() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
      );

      final cameraController = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      status = BarcodeScannerStatus.available(cameraController);
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  void scanWithImagePicker() async {
    await status.cameraController!.stopImageStream();
    final response = await ImagePicker().getImage(source: ImageSource.gallery);

    final inputImage = InputImage.fromFilePath(response!.path);
    scannerBarCode(inputImage);
  }

  Future<void> scannerBarCode(InputImage inputImage) async {
    try {
      if (status.cameraController != null &&
          status.cameraController!.value.isStreamingImages) {
        status.cameraController!.stopImageStream();
      }

      final barcodes = await barcodeScanner.processImage(inputImage);
      var barcode;

      for (Barcode item in barcodes) {
        barcode = item.value.displayValue;
      }

      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        status.cameraController!.dispose();
      } else {
        getAvailableCameras();
      }

      return;
    } catch (e) {
      print(e);
    }
  }

  void scanWithCamera() {
    Future.delayed(Duration(seconds: 10)).then((value) {
      if (status.cameraController != null &&
          status.cameraController!.value.isStreamingImages) {
        status.cameraController!.stopImageStream();
      }

      status = BarcodeScannerStatus.error("Timeout de leitura do boleto!");
    });

    listenCamera();
  }

  void listenCamera() {
    if (!status.cameraController!.value.isStreamingImages)
      status.cameraController!.startImageStream(
        (cameraImage) async {
          try {
            final WriteBuffer allBytes = WriteBuffer();
            for (Plane plane in cameraImage.planes) {
              allBytes.putUint8List(plane.bytes);
            }

            final bytes = allBytes.done().buffer.asUint8List();
            final Size imageSize = Size(
                cameraImage.width.toDouble(), cameraImage.height.toDouble());

            final InputImageRotation imageRotation =
                InputImageRotation.Rotation_0deg;

            final InputImageFormat inputImageFormat =
                InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
                    InputImageFormat.NV21;

            final planeData = cameraImage.planes.map(
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

            final inputImageCamera = InputImage.fromBytes(
                bytes: bytes, inputImageData: inputImageData);

            await Future.delayed(Duration(seconds: 3));
            await scannerBarCode(inputImageCamera);
          } catch (e) {
            print(e);
          }
        },
      );
  }
}
