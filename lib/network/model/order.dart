import 'package:gigantic_ticket_wallet/network/model/ticket.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

/// order returned by api
class Order {
  /// constructor
  Order({
    required this.id,
    required this.orderReference,
    required this.event,
    required this.venue,
    required this.startTime,
    required this.tickets,
  });

  /// convert json to order
  Order.fromJson(String orderId, dynamic json) {
    try {
      if (json case {
      'order_ref': final String orderReference,
      'event': final dynamic event,
      'tickets': final Map<String, dynamic> tickets
      }) {
        var eventTitle = 'test';
        var venueTitle = 'test';
        var eventStartTime = 0;

        if (event case {
        'event_title': final String event,
        'venue_title': final String venue,
        'event_start_time': final String startTime,
        }) {
          eventTitle = event;
          venueTitle = venue;
          eventStartTime = int.tryParse(startTime) ?? 0;
        }

        final orderTickets = List<Ticket>.empty(growable: true);
        for (final ticket in tickets.entries) {
          try {
            orderTickets.add(Ticket.fromJson(ticket.key, ticket.value));
          } catch(_) {

          }
        }

        final startTime = CommonDateUtils.getDateFromInt(eventStartTime);

        id = orderId;
        this.orderReference = orderReference;
        this.event = eventTitle;
        venue = venueTitle;
        this.startTime = startTime;
        this.tickets = orderTickets;
      }  else {
        throw Exception('unable to map to json');
      }
    } catch (_) {
      throw Exception('unable to map to json');
    }
  }

  ///
  late final String id;
  ///
  late final String orderReference;
  ///
  late final String event;
  ///
  late final String venue;
  /// event start time
  late final DateTime startTime;
  /// tickets that are linked to this order
  late final List<Ticket> tickets;
}
