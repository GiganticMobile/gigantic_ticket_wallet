import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

///this handles how a barcode is displayed
class BarcodeView extends StatefulWidget {
  /// constructor
  const BarcodeView({
    required String barcode,
    required DateTime viewAt,
    super.key,}) : _barcode = barcode, _viewAt = viewAt;

  final String _barcode;
  ///this is the time in which the user can view the barcode.
  final DateTime _viewAt;

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {

  late Timer _timer;
  bool _canViewBarcode = false;

  @override
  void initState() {
    _timer = Timer.periodic(
        const Duration(minutes: 1),
            (Timer timer) {
              _checkDate();
            },);

    _checkDate();

    super.initState();
  }

  void _checkDate() {
    if (widget._viewAt.compareTo(DateTime.now()) <= 0) {
      _timer.cancel();
      setState(() {
        _canViewBarcode = true;
      });
    } else {
      if (_canViewBarcode == true) {
        setState(() {
          _canViewBarcode = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
      AnimatedOpacity(
        opacity: _canViewBarcode ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: QRCodeView(barcode: widget._barcode,),
      ),

      AnimatedOpacity(
        opacity: !_canViewBarcode ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: const EmptyQRCode(),
      ),
    ],);
  }
}

/// this is a widget that is displayed when the qr code
/// is hidden.
class EmptyQRCode extends StatelessWidget {
  /// constructor
  const EmptyQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Theme.of(context).colorScheme.onBackground),
      ),
      child: const Center(
        child: Text('QR code will be available closer to the event',
          style: TextStyle(fontSize: 18,),
          textAlign: TextAlign.center,),
      ),);
  }
}

/// handles displaying the qr code and animating its border
class QRCodeView extends StatefulWidget {
  ///constructor
  const QRCodeView({required String barcode, super.key}) : _barcode = barcode;

  final String _barcode;

  @override
  State<QRCodeView> createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> with TickerProviderStateMixin {

  late Animation<double> animation;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  final Tween<double> _tween = Tween(begin: 0, end: 100);

  @override
  void initState() {
    animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            //border: Border.all(color: Colors.red),
          ),
          child: CustomPaint(
            painter: QRCoderPainter(animation.value),
            child: QrImageView(
              data: widget._barcode,
              size: 200,
            ),
          ),
        ),
      ],);
  }
}

/// this animates the boarder of the qr code
class QRCoderPainter extends CustomPainter {
  /// constructor
  QRCoderPainter(this._location);

  final double _location;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
    //..color = Colors.lightBlue
      ..shader = ui.Gradient.linear(
          ui.Offset(0, (size.height / 3)),
          ui.Offset(0, (size.width - (size.height / 3))), [
        Colors.blue,
        Colors.green,
      ])
      ..strokeWidth = 10.0;

    //the border of a square
    final borderLength = size.width * 4;
    // the length of the line that travels around the border
    final lineLength = (size.width / 100) * 20;
    // the progress is the border length plus the line length because
    //the animated line needs to travel around the border and have time
    // to disappear.
    final progress = ((borderLength + lineLength) / 100) * _location;

    final double x;
    final double y;

    //this is the point at the front of the animated line
    final double point1;
    if (progress < borderLength) {
      point1 = progress;
    } else {
      // the front of the animated line has traveled around the border
      // and is now waiting the the end of the animated line to catch up
      point1 = borderLength;
    }

    if (point1 < size.width) {
      //travelling along the top of the border from left to right
      x = point1;
      y = 0;
    } else if (point1 < (size.width * 2)) {
      //travelling along the right side of the border from top to bottom
      x = size.width;
      y = point1 - size.width;
    } else if (point1 < (size.width * 3)) {
      //travelling along the bottom of the bottom from right to left
      x = size.width - (point1 - (size.width * 2));
      y = size.width;
    } else {
      //travelling along the left side of the border from bottom to top
      x = 0;
      y = size.width - (point1 - (size.width * 3));
    }

    final double trailingX;
    final double trailingY;

    //this represents the end of the animated line
    final double point2;

    if (progress > lineLength) {
      point2 = progress - lineLength;
    } else {
      //the end of the animated line will wait until the
      //full length of the animated line is visible.
      point2 = 0;
    }

    if (point2 < size.width) {
      //travelling along the top of the border from left to right
      trailingX = point2;
      trailingY = 0;
    } else if (point2 < (size.width * 2)) {
      //travelling along the right side of the border from top to bottom
      trailingX = size.width;
      trailingY = point2 - size.width;
    } else if (point2 < (size.width * 3)) {
      //travelling along the bottom of the bottom from right to left
      trailingX = size.width - (point2 - (size.width * 2));
      trailingY = size.width;
    } else {
      //travelling along the left side of the border from bottom to top
      trailingX = 0;
      trailingY = size.width - (point2 - (size.width * 3));
    }

    final path = Path()

      ..moveTo(trailingX, trailingY);

    //this handles corners.
    //when the animated line reaches a corner this will bend the line around
    //the corner
    if (trailingX < size.width && x == size.width && trailingY == 0) {
      // top right corner
      path..lineTo(size.width, 0)
        ..moveTo(size.width, 0);
    } else if (trailingX == size.width
        && trailingY < size.width
        && y == size.width) {
      //bottom right corner
      path..lineTo(size.width, size.width)
        ..moveTo(size.width, size.width);
    } else if (trailingX > 0 && x == 0 && trailingY == size.width) {
      //bottom left corner
      path..lineTo(0, size.width)
        ..moveTo(0, size.width);
    } else if (trailingX == 0 && x == 0 && trailingY < 0) {
      //top left corner
      path..lineTo(0, size.width)
        ..moveTo(0, size.width);
    }

    path.lineTo(x, y);

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
