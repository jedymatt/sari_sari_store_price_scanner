import 'package:barcode_widget/barcode_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode;

Barcode mobileScannerFormatToBarcodeWidget(BarcodeFormat format) {
  switch (format) {
    case BarcodeFormat.ean13:
      return Barcode.ean13();
    case BarcodeFormat.ean8:
      return Barcode.ean8();
    case BarcodeFormat.code39:
      return Barcode.code39();
    case BarcodeFormat.code93:
      return Barcode.code93();
    case BarcodeFormat.upcA:
      return Barcode.upcA();
    case BarcodeFormat.upcE:
      return Barcode.upcE();
    case BarcodeFormat.code128:
      return Barcode.code128();
    case BarcodeFormat.qrCode:
      return Barcode.qrCode();
    case BarcodeFormat.codabar:
      return Barcode.codabar();
    case BarcodeFormat.pdf417:
      return Barcode.pdf417();
    case BarcodeFormat.dataMatrix:
      return Barcode.dataMatrix();
    case BarcodeFormat.aztec:
      return Barcode.aztec();
    default:
      throw UnimplementedError(
        'Barcode format $format is not supported by barcode_widget package',
      );
  }
}
