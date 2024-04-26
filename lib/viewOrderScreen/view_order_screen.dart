import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// displays general information about an order and the related event
class ViewOrderScreen extends StatelessWidget {
  /// constructor
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('123-456-789'),
          ),
        body: ListView(children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(4),),
          ),

          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.confirmation_num_outlined),
                title: const Text('View your tickets'),
                subtitle: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('3 x seats'),
                    Text('2 x general admission'),
                ],),
                trailing: IconButton(onPressed: () {

                }, icon: const Icon(Icons.arrow_forward),),
                shape: Border.all(color: Colors.cyan),
              ),

              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Transfer tickets to a friend'),
                trailing: IconButton(onPressed: () {

                }, icon: const Icon(Icons.arrow_forward),),
                shape: Border.all(color: Colors.cyan),
              ),

              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Contact customer services'),
                trailing: IconButton(onPressed: () {

                }, icon: const Icon(Icons.arrow_forward),),
                shape: Border.all(color: Colors.cyan),
              ),
            ],),
          ),

          const Text('EVENT TITLE'),

          const Text('Riverside stadium'),

          const Text('Information'),

          const Text('Event description'),

          const Text('Venue'),

          const QRCodeView(),

        ],),
        ),
    );
  }
}

/// handles displaying the qr code and animating its border
class QRCodeView extends StatefulWidget {
  ///constructor
  const QRCodeView({super.key});

  @override
  State<QRCodeView> createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> with TickerProviderStateMixin {

  late Animation<double> animation;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

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
        height: 220,
        width: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.red),
        ),
        child: CustomPaint(
          painter: QRCoderPainter(animation.value),
          child: QrImageView(
            data: '123456',
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

    //this starts at 0,0 finishes 210, 0
    /*final double x;
    final double y = 0;
    if (progress < (size.width)) {
      x = progress;
    } else {
      x = size.width;
    }*/

    //this starts are -10, 0 finishes 200, 0
    /*final double trailingX;
    final double trailingY = 0;
    if (progress > lineLength) {
      trailingX = progress - lineLength;
    } else {
      trailingX = 0;
    }*/

    /*
    final path = Path();
    path.moveTo(x, y);

    path.lineTo(trailingX, trailingY);*/

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

/// paints a custom icon
class OrderPainter  extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue
      ..strokeWidth = 10.0;

    final path = Path()

    ..moveTo(0, 0)

    ..lineTo(0, 50)

    ..moveTo(0, 50)
    
    ..addOval(Rect.fromCenter(
        center: const Offset(0, 75),
        width: 50,
        height: 50,),)

    ..moveTo(0, 100)

    ..lineTo(0, 150);
    
    canvas.drawPath(path, paint);


    //final center = size/2;
    final cyclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlue
      ..strokeWidth = 10.0;
    canvas.drawCircle(const Offset(0, 75), 25, cyclePaint);

    const style = TextStyle(color: Colors.black, fontSize: 18,);

    final paragraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          fontSize:   style.fontSize,
          fontFamily: style.fontFamily,
          fontStyle:  style.fontStyle,
          fontWeight: style.fontWeight,
          textAlign: TextAlign.justify,
          maxLines: 1,
          ellipsis: '...',
        ),
    )
      ..pushStyle(style.getTextStyle())
      ..addText('gates open 15:30');

    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 150));

    canvas.drawParagraph(paragraph, const Offset(40, 60));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
