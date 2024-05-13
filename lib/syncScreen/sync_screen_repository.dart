import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/database/model/ticket.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';

/// this handles business logic of the sync screen
class SyncScreenRepository extends SyncScreenRepositoryInterface {
  /// constructor
  SyncScreenRepository({
    required OrderAPIInterface api,
    required OrderDatabaseInterface orderDatabase,
    required EventDatabaseInterface eventDatabase,
    required TicketDatabaseInterface ticketDatabase,})
      : _api = api,
        _orderDatabase = orderDatabase,
        _eventDatabase = eventDatabase,
        _ticketDatabase = ticketDatabase;

  final OrderAPIInterface _api;
  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;
  final TicketDatabaseInterface _ticketDatabase;

  @override
  Future<void> syncOrders() async {

    final apiOrders = await _api.getOrders();

    for (final order in apiOrders) {
      await _orderDatabase.addOrder(
        Order.fromNetwork(order),
      );

      await _eventDatabase.addEvent(
        Event.fromNetwork(order.id, order.event),
      );

      for (final ticket in order.tickets) {
        await _ticketDatabase.addTicket(
          Ticket.fromNetwork(order.id, ticket),
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
