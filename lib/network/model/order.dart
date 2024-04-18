
import 'package:gigantic_ticket_wallet/network/model/ticket.dart';

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

  ///
  final String id;
  ///
  final String orderReference;
  ///
  final String event;
  ///
  final String venue;
  /// event start time
  final DateTime startTime;
  /// tickets that are linked to this order
  List<Ticket> tickets;
}
