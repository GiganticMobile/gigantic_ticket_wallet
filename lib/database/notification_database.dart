import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';

///
class NotificationDatabase extends NotificationDatabaseInterface {
  /// constructor
  NotificationDatabase({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<void> addNotification(NotificationData notification) async {
    final inserting = NotificationCompanion.insert(
        order: Value(notification.order),
        notificationId: Value(notification.notificationId),
        title: notification.title,
        body: notification.body,
        type: notification.type,
        createdAt: notification.createdAt,);

    /**
    There might be a problem of notification being duplicated if the order
        is updated.

        Also any old orders should be deleted. Either by time, or should
        only be deleted if the order it is linked to is deleted.
     */

    await _database.into(_database.notification)
        .insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<NotificationData>> getNotifications() async {
    final notifications = await _database.select(_database.notification).get();

    return notifications;
  }

  @override
  Future<bool> hasUnreadNotifications() async {
    final unreadNotifications =
    await (_database.select(_database.notification)
        ..where((notification) => notification.seen.equals(false)))
        .get();

    // if the app needs to know the amount of unread notification
    //then return the unreadNotifications length

    return unreadNotifications.isNotEmpty;
  }

  @override
  Future<void> setAllNotificationsAsRead() async {
    await (_database.update(_database.notification)
      ..where((notification) => notification.seen.equals(false)))
        .write(const NotificationCompanion(seen: Value(true)));
  }

}

///
abstract class NotificationDatabaseInterface {

  ///
  Future<void> addNotification(NotificationData notification);

  ///
  Future<List<NotificationData>> getNotifications();

  /// this is used to inform the user that they have notifications which
  /// they have not seen.
  Future<bool> hasUnreadNotifications();

  ///if the user goes on the notification screen then all notifications
  ///should be set as read / seen.
  Future<void> setAllNotificationsAsRead();

}
