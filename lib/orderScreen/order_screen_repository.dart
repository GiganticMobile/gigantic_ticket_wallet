import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_item.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

/// this handles the business logic for the order screen
class OrderScreenRepository extends OrderScreenRepositoryInterface {
  /// Constructor
  OrderScreenRepository({
    required OrderDatabaseInterface orderDatabase,
    required EventDatabaseInterface eventDatabase,
}) : _orderDatabase = orderDatabase, _eventDatabase = eventDatabase;

  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;

  @override
  Future<List<OrderItem>> getOrders() async {
    final databaseOrders = await _orderDatabase.getOrders();

    databaseOrders.sort((a, b) => a.startTime.compareTo(b.startTime));

    final orderItemList = List<OrderItem>.empty(growable: true);

    for (final order in databaseOrders) {
      final databaseEvent = await _eventDatabase.getEventByOrder(order.id);

      final String eventStartDate;
      if (databaseEvent != null) {
        final eventDateTime =
        DateTime.fromMillisecondsSinceEpoch(databaseEvent.doorsOpenTime);

        eventStartDate =
            CommonDateUtils.convertDateTimeToLongDateString(eventDateTime);
      } else {
        eventStartDate = '';
      }

      orderItemList.add(OrderItem(
        id: order.id,
        imageUrl: databaseEvent?.eventImage ?? '',
        eventName: databaseEvent?.title ?? '',
        eventStartDate: eventStartDate,
        venueLocation: databaseEvent?.venueAddress ?? '',
        orderReference: order.reference,
        ticketAmount: 3,
        transferredTicketAmount: 3,),);
    }

    return orderItemList;
  }

}

///
abstract class OrderScreenRepositoryInterface {

  ///
  Future<List<OrderItem>> getOrders();
}
