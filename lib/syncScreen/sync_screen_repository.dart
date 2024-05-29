import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/database/model/ticket.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart' as api;
import 'package:gigantic_ticket_wallet/network/order_api.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_handler.dart';

/// this handles business logic of the sync screen
class SyncScreenRepository extends SyncScreenRepositoryInterface {
  /// constructor
  SyncScreenRepository({
    required OrderAPIInterface api,
    required OrderDatabaseInterface orderDatabase,
    required EventDatabaseInterface eventDatabase,
    required TicketDatabaseInterface ticketDatabase,
    required NotificationHandler notificationHandler,
  })
      : _api = api,
        _orderDatabase = orderDatabase,
        _eventDatabase = eventDatabase,
        _ticketDatabase = ticketDatabase,
        _notificationHandler = notificationHandler;

  final OrderAPIInterface _api;
  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;
  final TicketDatabaseInterface _ticketDatabase;
  final NotificationHandler _notificationHandler;

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

      if (order.orderReference == '0471-7459-4332') {
        await _setupNotifications(order);
      }
    }
  }

  Future<void> _setupNotifications(api.Order order) async {
    if (order.event.doorsOpenTime != null) {
      await _notificationHandler.createReminderNotification(
          order.id,
          order.event.title,
          order.event.doorsOpenTime!,);

      // not all events have an end time so if null use the event start time
      final ratingDate = order.event.endTime ?? order.event.doorsOpenTime!;
      await _notificationHandler.createRatingNotification(
          order.id,
          order.event.title,
          ratingDate,);
    }
  }

}

///
abstract class SyncScreenRepositoryInterface {

  /// this gets the latest version of the orders an tickets
  /// and saves them to the database
  Future<void> syncOrders();
}
