import 'dart:ui';

import 'package:flutter/material.dart';

/// displays general information about an order and the related event
class ViewOrderScreen extends StatelessWidget {
  /// constructor
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: Center(child: CustomPaint(
          painter: OrderPainter(),
        ),),
        ),
    );
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

    final paragraphBuilder = ParagraphBuilder(
        ParagraphStyle(
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
      ..layout(const ParagraphConstraints(width: 150));

    canvas.drawParagraph(paragraph, const Offset(40, 60));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
