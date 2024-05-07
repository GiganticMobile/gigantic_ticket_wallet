import 'package:gigantic_ticket_wallet/network/model/event.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart';

/// order returned by api
class Order {
  /// constructor
  Order({
    required this.id,
    required this.orderReference,
    required this.event,
    required this.tickets,
    required this.hasRefundPlan,
  });

  /// convert json to order
  Order.fromJson(String orderId, dynamic json) {
    try {
      if (json case {
      'order_ref': final String orderReference,
      'event': final dynamic event,
      'tickets': final Map<String, dynamic> tickets,
      'order_has_refund_plan': final bool hasRefundPlan,
      }) {

        this.event = Event.fromJson(event);

        final orderTickets = List<Ticket>.empty(growable: true);
        for (final ticket in tickets.entries) {
          try {
            orderTickets.add(Ticket.fromJson(ticket.key, ticket.value));
          } catch(_) {

          }
        }

        id = orderId;
        this.orderReference = orderReference;
        this.tickets = orderTickets;
        this.hasRefundPlan = hasRefundPlan;
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
  late final Event event;
  ///
  //late final String venue;
  /// event start time
  //late final DateTime startTime;
  /// tickets that are linked to this order
  late final List<Ticket> tickets;
  ///
  late final bool hasRefundPlan;
}
