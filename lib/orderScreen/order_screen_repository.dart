import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_item.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

/// this handles the business logic for the order screen
class OrderScreenRepository extends OrderScreenRepositoryInterface {
  /// Constructor
  OrderScreenRepository({
    required OrderDatabaseInterface orderDatabase,
}) : _orderDatabase = orderDatabase;

  final OrderDatabaseInterface _orderDatabase;

  @override
  Future<List<OrderItem>> getOrders() async {
    final databaseOrders = await _orderDatabase.getOrders();

    databaseOrders.sort((a, b) => a.startTime.compareTo(b.startTime));

    return databaseOrders.map((order) {
      final eventDateTime =
      DateTime.fromMillisecondsSinceEpoch(order.startTime);

      final eventStartDate =
      CommonDateUtils.convertDateTimeToLongDateString(eventDateTime);

      return OrderItem(
          imageUrl: '',
          eventName: order.event,
          eventStartDate: eventStartDate,
          venueLocation: order.venue,
          orderReference: order.reference,
          ticketAmount: 3,
          transferredTicketAmount: 3,);
    }).toList();
  }

}

///
abstract class OrderScreenRepositoryInterface {

  ///
  Future<List<OrderItem>> getOrders();
}
