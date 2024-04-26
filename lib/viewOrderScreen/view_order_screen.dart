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

          /** it might be better if the event title replaces the
           * event reference, and the event reference and event
           * date go in the event information section.
           * This would allow the user to see the ticket
           * selector without the need to scroll.
           */
          const ScreenTitle(),

          const TicketView(),

          const TicketSelector(),

          const Divider(color: Colors.green,),

          const EventSchedule(),

          const Divider(color: Colors.green,),

          const EventInfo(),

          const Divider(color: Colors.green,),

          const VenueInfo(),

          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Contact customer services'),
              trailing: IconButton(onPressed: () {

              }, icon: const Icon(Icons.arrow_forward),),
              shape: Border.all(color: Colors.cyan),
            ),
          ),

        ],),
        ),
    );
  }
}

/// this widget contains the event title and date
class ScreenTitle extends StatelessWidget {
  /// constructor
  const ScreenTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('Event title',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        Text('Saturday 16 March 2024'),
      ],),
    );
  }
}

///displays a ticket
class TicketView extends StatelessWidget {
  ///constructor
  const TicketView({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),),
      child: const Column(
        children: [

          //QRCodeView(),
          EmptyQRCode(),

          Text('Ticket heading',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text('Ticket label',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

          //face value
          Text('£75.00'),

          Divider(color: Colors.green,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              Text('Block'),
              Text('Block name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),),
            ],),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Row'),
                Text('AB',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),),
              ],),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Seat'),
                Text('123',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),),
              ],),
          ],),

          Divider(color: Colors.green,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Entrance'),
                  Text('Entrance name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Stand'),
                  Text('stand name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Codes'),
                  Text('Code name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),
            ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gate'),
                  Text('Gate name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Area'),
                  Text('Area name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Turnstiles'),
                  Text('Turnstiles name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),
            ],),
          ],),

          Divider(color: Colors.green,),

          ListTile(
            leading: Icon(Icons.more_horiz),
            title: Text('Ticket options'),),

      ],),
    );
  }
}

/// select ticket
class TicketSelector extends StatelessWidget {
  ///constructor
  const TicketSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: IconButton.filled(
                  onPressed: () {},
                  icon: Text('$index',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
              );
            },),
        ),
      ],
    );
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
  const QRCodeView({super.key});

  @override
  State<QRCodeView> createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> with TickerProviderStateMixin {

  late Animation<double> animation;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: false);

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

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

///widget the contains the event schedule
class EventSchedule extends StatelessWidget {
  /// constructor
  const EventSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: CustomPaint(
          painter: EventSchedulePainter(),
      ),
    );
  }
}

///this draws the event schedule
class EventSchedulePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, ui.Size size) {

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue
      ..strokeWidth = 8.0;

    //this draws a line of cycles linked by lines
    //this maps out the event schedule
    final path = Path()

    ..addOval(Rect.fromCenter(
    center: const Offset(25, 15),
    width: 25,
    height: 25,),)

    ..moveTo(25, 30)

    ..lineTo(25, 50)

    ..addOval(Rect.fromCenter(
      center: const Offset(25, 65),
      width: 25,
      height: 25,),)

    ..moveTo(25, 80)

    ..lineTo(25, 100)

    ..addOval(Rect.fromCenter(
      center: const Offset(25, 115),
      width: 25,
      height: 25,),);

    canvas.drawPath(path, paint);

    // this draws the times (as text) of the event schedule
    // each time is place next to a circle
    const style = TextStyle(
        color: Colors.black,
        fontSize: 16,
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

    var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle())
      ..addText('Gates at 15:30');

    var paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 120));

    canvas.drawParagraph(paragraph, const Offset(45, 6));

    paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle())
      ..addText('Begins at 15:30');

    paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 150));

    canvas.drawParagraph(paragraph, const Offset(45, 56));

    paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle())
      ..addText('Ends at 15:30');

    paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 150));

    //it is 106 because the top of the circle is at 100
    //and adding the 6 (i.e. 1/4 of the height of the circle)
    //will put the centre of the text line with the centre
    // of the circle
    canvas.drawParagraph(paragraph, const Offset(45, 106));

    //this fills a circle in the schedule and is used to represent
    //that the schedule is at a specific point
    final cyclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green //green for on time red for delayed
      ..strokeWidth = 10.0;
    canvas.drawCircle(const Offset(25, 15), 10, cyclePaint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

/// this contains event information
class EventInfo extends StatelessWidget {
  /// constructor
  const EventInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text('Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        const Text('general information about the event'),

        Container(
          height: 200,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.cyanAccent,
            borderRadius: BorderRadius.circular(4),),
        ),
      ],),
    );
  }
}

/// this contains venue information
class VenueInfo extends StatelessWidget {
  /// constructor
  const VenueInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('Venue',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        //address of the venue
        Text('Royal concert hall'),
        Text('Theatre square'),
        Text('Nottingham'),
        Text('NG1 5ND'),
        Text('UK'),

        Text('general information about the venue'),
      ],),
    );
  }
}
