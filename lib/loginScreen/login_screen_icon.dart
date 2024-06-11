import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

///this is the icon at the top of the login screen
class LoginScreenIcon extends StatelessWidget {
  /// constructor
  const LoginScreenIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CustomPaint(
        painter: LoginIconPainter(
          iconColor: Theme.of(context).colorScheme.primaryContainer,
          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

///This draws the login screen icon
class LoginIconPainter extends CustomPainter {
  /// constructor
  LoginIconPainter({
    required this.iconColor,
    required this.textColor,
});

  ///the background color of the icon
  Color iconColor;
  ///the color of the text on the icon
  Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = iconColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    _rotate(canvas, size.width, size.height, 10);

    canvas.drawRRect(RRect.fromRectXY(Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 80, height: 80,), 2, 2,), backgroundPaint,);

    final style = TextStyle(
      color: textColor,
      fontSize: 56,
      fontWeight: FontWeight.bold,);
    final paragraphStyle = ui.ParagraphStyle(
      fontSize:   style.fontSize,
      fontFamily: style.fontFamily,
      fontStyle:  style.fontStyle,
      fontWeight: style.fontWeight,
      textAlign: TextAlign.justify,
      maxLines: 1,
      ellipsis: '...',
    );

    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle())
      ..addText('g');

    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 80));

    _rotate(canvas, size.width, size.height, -10);

    canvas.drawParagraph(paragraph,
      Offset((size.width / 2) - 20, (size.height / 2) - 40),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _rotate(Canvas canvas, double width, double height, double rotation) {
    final angle = (rotation / 360) * 6.28;
    final r = sqrt(width * width + height * height) / 2;
    final alpha = atan(height / width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = width / 2 - shiftX;
    final translateY = height / 2 - shiftY;
    canvas..translate(translateX, translateY)
    ..rotate(angle);
  }

}
