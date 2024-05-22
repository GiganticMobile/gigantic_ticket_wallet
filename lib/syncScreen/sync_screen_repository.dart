import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';
import 'package:gigantic_ticket_wallet/database/model/notification.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/database/model/ticket.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart' as api;
import 'package:gigantic_ticket_wallet/network/order_api.dart';

/// this handles business logic of the sync screen
class SyncScreenRepository extends SyncScreenRepositoryInterface {
  /// constructor
  SyncScreenRepository({
    required OrderAPIInterface api,
    required OrderDatabaseInterface orderDatabase,
    required EventDatabaseInterface eventDatabase,
    required TicketDatabaseInterface ticketDatabase,
    required NotificationDatabaseInterface notificationDatabase,
  })
      : _api = api,
        _orderDatabase = orderDatabase,
        _eventDatabase = eventDatabase,
        _ticketDatabase = ticketDatabase,
        _notificationDatabase = notificationDatabase;

  final OrderAPIInterface _api;
  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;
  final TicketDatabaseInterface _ticketDatabase;
  final NotificationDatabaseInterface _notificationDatabase;

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

    ///prevent the app from create a notification for a past event
    final notificationsAllowed =
    await AwesomeNotifications().isNotificationAllowed();

    //check that event is not in the past to ensure that the
    //user does not get a notification from an event that has already happened
    if (order.event.doorsOpenTime != null
        && order.event.doorsOpenTime!.compareTo(DateTime.now()) >= 0) {

      final existingNotifications =
      await _notificationDatabase.getNotificationsByOrder(order.id);

      //this order does not have a reminder notification
      if (existingNotifications.where(
              (item) => item.type == NotificationType.reminder,
        ).isEmpty)
      {
        final reminderId =
            '${order.orderReference}${NotificationType.reminder}'.hashCode;
        const reminderTitle = 'Event Reminder';
        final reminderBody = '${order.event.title} 1 hour away';
        final reminderDate = DateTime.now().add(const Duration(minutes: 1));

        final reminder = NotificationData(
          id: 0,
          order: order.id,
          notificationId: reminderId,
          title: reminderTitle,
          body: reminderBody,
          type: NotificationType.reminder,
          seen: false,
          createdAt: reminderDate,);

        await _notificationDatabase.addNotification(reminder);

        if (notificationsAllowed) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: reminderId,
              channelKey: 'basic_channel',
              title: reminderTitle,
              body: reminderBody,
              category: NotificationCategory.Reminder,
              wakeUpScreen: true,
            ),
            schedule: NotificationCalendar.fromDate(
              date: reminderDate,),
          );
        }
      }

      //this order does not have a rating notification
      if (existingNotifications.where(
            (item) => item.type == NotificationType.rate,
      ).isEmpty) {
        final ratingId = '${order.orderReference}${NotificationType.rate}'
            .hashCode;
        const ratingTitle = 'Rating';
        final ratingBody = 'How do you rate your time at ${order.event.title}';
        final ratingDate = DateTime.now().add(const Duration(minutes: 2));

        final rating = NotificationData(
          id: 0,
          order: order.id,
          notificationId: ratingId,
          title: ratingTitle,
          body: ratingBody,
          type: NotificationType.rate,
          seen: false,
          createdAt: ratingDate,);

        await _notificationDatabase.addNotification(rating);

        if (notificationsAllowed) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: ratingId,
              channelKey: 'basic_channel',
              title: ratingTitle,
              body: ratingBody,
              category: NotificationCategory.Reminder,
              wakeUpScreen: true,
            ),
            schedule: NotificationCalendar.fromDate(
              date: ratingDate,),
          );
        }
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
