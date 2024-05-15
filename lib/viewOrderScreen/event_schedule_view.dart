import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

///Used to display a the event schedule on the view order screen
class EventScheduleView extends StatelessWidget {
  /// constructor
  const EventScheduleView({required List<ScheduleItem> schedule, super.key})
      : _schedule = schedule;

  final List<ScheduleItem> _schedule;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      //this prevents the schedule from overlapping with other widgets
      child: SingleChildScrollView(
        child: SizedBox(
          //this creates a box that hold the full schedule
          height: (55 * _schedule.length).toDouble(),
          child: CustomPaint(
            painter: EventSchedulePainter(_schedule),
          ),
        ),
      ),
    );
  }
}

///this draws the event schedule
class EventSchedulePainter extends CustomPainter {
  /// constructor
  EventSchedulePainter(List<ScheduleItem> schedule) {
    _schedule = schedule;
    _paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue
      ..strokeWidth = 8.0;

  }

  late final List<ScheduleItem> _schedule;
  late final Paint _paint;

  @override
  void paint(Canvas canvas, ui.Size size) {

    const startLocation = Offset(25, 20);

    _schedule.asMap().forEach((key, value) {
      final Offset location;
      if ((key + 1) == 1) {
        //first item in the schedule
        location = Offset(
          startLocation.dx,
          startLocation.dy * (key + 1),
        );
      } else {
        //the (20 * key) was added to make room for the line connecting
        //schedule items together
        //the plus (15) stops the circles from over lapping
        location = Offset(
          startLocation.dx,
          ((startLocation.dy * (key + 1)) + (15 * key)) + (20 * key),
        );
      }

      _drawScheduleItem(canvas, location, value,);

      if ((key + 1) != _schedule.length) {
        final path = Path()
          ..moveTo(location.dx, location.dy + 15)

          ..lineTo(location.dx, location.dy + 40);

        canvas.drawPath(path, _paint);
      }

    });

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawScheduleItem(Canvas canvas, Offset location, ScheduleItem scheduleItem) {

    final path = Path()

    // const Offset(25, 15),
    ..addOval(Rect.fromCenter(
      center: location,
      width: 25,
      height: 25,),);

    canvas.drawPath(path, _paint);

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

    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle());

    if (scheduleItem.delay != null) {
      final delay = CommonDateUtils.convertTimeToString(scheduleItem.delay!);
      final delayedBy = scheduleItem.delay!.difference(scheduleItem.time);
      paragraphBuilder.addText(
          '${scheduleItem.title} at $delay delay ${delayedBy.inMinutes} minutes',
      );
    } else {
      final time = CommonDateUtils.convertTimeToString(scheduleItem.time);
      paragraphBuilder.addText('${scheduleItem.title} at $time');
    }

    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 280));

    canvas.drawParagraph(paragraph, Offset(
        location.dx + 20,
        location.dy - (15 / 3),),
    );

    //const Offset(45, 6)

    if (scheduleItem.delay != null) {
      final cyclePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red //green for on time red for delayed
        ..strokeWidth = 10.0;
      canvas.drawCircle(location, 10, cyclePaint);
    } else {
      if (DateTime.now().compareTo(scheduleItem.time) >= 0) {
        //this fills a circle in the schedule and is used to represent
        //that the schedule is at a specific point
        final cyclePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.green //green for on time red for delayed
          ..strokeWidth = 10.0;
        canvas.drawCircle(location, 10, cyclePaint);
      }
    }
  }

}

///this is the data that will be displayed in the vent schedule
class ScheduleItem {
  ///constructor
  ScheduleItem({required this.title, required this.time, this.delay});
  ///this is what the time refers to such as event starts at
  String title;
  ///this is the time of the schedule
  DateTime time;
  ///this is the delayed time of the schedule
  DateTime? delay;
}
