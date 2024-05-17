import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/notification.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';

///
class NotificationScreenRepository
    extends NotificationScreenRepositoryInterface {
  ///constructor
  NotificationScreenRepository({
    required NotificationDatabaseInterface database,
  }) : _database = database;

  final NotificationDatabaseInterface _database;

  @override
  Future<void> addNotification() async {
    final notification = NotificationData(
        id: 0,
        title: 'Test',
        body: 'This is a test notification',
        type: NotificationType.info,
        seen: false,
        createdAt: DateTime.now(),);

    await _database.addNotification(notification);
  }

  @override
  Future<List<NotificationData>> getAllNotifications() {
    return _database.getNotifications();
  }

  @override
  Future<void> setAllNotificationsAsRead() {
    return _database.setAllNotificationsAsRead();
  }

}

///
abstract class NotificationScreenRepositoryInterface {

  ///
  Future<void> addNotification();

  ///
  Future<List<NotificationData>> getAllNotifications();

  /// when the user goes on the notifications screen the app
  ///should mark all notifications as read
  Future<void> setAllNotificationsAsRead();

}
