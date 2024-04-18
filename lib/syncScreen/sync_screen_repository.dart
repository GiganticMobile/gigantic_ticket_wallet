import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';

/// this handles business logic of the sync screen
class SyncScreenRepository extends SyncScreenRepositoryInterface {
  /// constructor
  SyncScreenRepository({
    required OrderAPIInterface api,
    required OrderDatabaseInterface orderDatabase,
    required TicketDatabaseInterface ticketDatabase,})
      : _api = api,
        _orderDatabase = orderDatabase,
        _ticketDatabase = ticketDatabase;

  final OrderAPIInterface _api;
  final OrderDatabaseInterface _orderDatabase;
  final TicketDatabaseInterface _ticketDatabase;

  @override
  Future<void> syncOrders() async {

    final apiOrders = await _api.getOrders();

    for (final order in apiOrders) {
      await _orderDatabase.addOrder(
          OrderData(
              id: order.id,
              reference: order.orderReference,
              event: order.event,
              venue: order.venue,
              startTime: order.startTime.millisecondsSinceEpoch,),
      );

      for (final ticket in order.tickets) {
        await _ticketDatabase.addTicket(
            TicketData(
                id: ticket.id,
                order: order.id,
                barcode: ticket.barcode,
                heading: ticket.heading,
                label: ticket.label,
                value: ticket.value,),
        );
      }
    }
  }

}

///
abstract class SyncScreenRepositoryInterface {

  /// this gets the latest version of the orders an tickets
  /// and saves them to the database
  Future<void> syncOrders();
}
