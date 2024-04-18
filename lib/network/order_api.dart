import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

/// handles interactions for the order api
class OrderAPI extends OrderAPIInterface {
  /// constructor
  OrderAPI({required OrderEndPointsInterface endPoints})
      : _endpoints = endPoints;

  final OrderEndPointsInterface _endpoints;

  @override
  Future<List<Order>> getOrders() async {
    final response = await _endpoints.getAllOrders();

    if (response == null) {
      return List.empty();
    }

    /*
    if (response.data['status'] == 'LOGIN SUCCESSFUL') {
      final result = LoginResult.fromJson(response.data);
      return result;
    } else {
      return null;
    }
     */
    
    return _mapJsonToOrders(response.data);
  }

  Future<List<Order>> _mapJsonToOrders(dynamic json) async {
    final orders = List<Order>.empty(growable: true);
    if (json case {
    'orders': final Map<String, dynamic> orderJson,
    }) {
      for (final orderId in orderJson.keys) {
        if (orderJson[orderId] case {
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
            if (ticket.value case {
            'barcode': final String barcode,
            'heading': final String heading,
            'label': final String label,
            'face_value': final String value,
            }) {
              //final startTime = DateTime.now().add(const Duration(minutes: 2))

              orderTickets.add(Ticket(
                  id: ticket.key,
                  barcode: barcode,
                  heading: heading,
                  label: label,
                  value: double.tryParse(value) ?? 0,),
              );

            }
          }

          final startTime = CommonDateUtils.getDateFromInt(eventStartTime);
          final order = Order(
              id: orderId,
              orderReference: orderReference,
              event: eventTitle,
              venue: venueTitle,
              startTime: startTime,
              tickets: orderTickets,);

          orders.add(order);
        }
      }
    }

    return orders;
  }
}

///
abstract class OrderAPIInterface {

  /// get orders from api
  Future<List<Order>> getOrders();

}
