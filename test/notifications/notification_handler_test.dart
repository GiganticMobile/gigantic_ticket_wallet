import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/notification.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_handler.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_settings.dart';

void main() {

  late AppDatabase database;

  setUp(() {
    database = AppDatabase.createInMemoryDatabase();
  });
  tearDown(() async {
    await database.close();
  });

  test('create reminder notification test', () async {

    final notificationDatabase = NotificationDatabase(database: database);
    final notificationHandler = NotificationHandler(
      notificationDatabase: notificationDatabase,
      notificationSettings: MockNotificationSettings(),
    );

    const expectedOrderId = '1';
    const expectedOrderTitle = 'title';
    final expectedStartTime = DateTime(2020, 1, 1, 2);
    await notificationHandler.createReminderNotification(
        expectedOrderId,
        expectedOrderTitle,
        expectedStartTime,);

    /*
    The app should only create a reminder notification once
    to avoid the possibility of the user getting duplicates of
    notifications that they have already seen.
     */
    const unexpectedOrderTitle = 'title1';
    await notificationHandler.createReminderNotification(
      expectedOrderId,
      unexpectedOrderTitle,
      expectedStartTime,);

    final notifications = await notificationDatabase
        .getNotificationsByOrder(expectedOrderId);

    expect(notifications, isNotEmpty,
        reason: 'notification list unexpectedly empty',);

    //check that the notification was not duplicated
    expect(notifications.length, 1,
      reason: 'unexpected notification list length',);

    final notification = notifications.first;

    expect(notification.order, expectedOrderId, reason: 'unexpected order id');
    const expectedNotificationBody = '$expectedOrderTitle 1 hour away';
    expect(notification.body, expectedNotificationBody,
        reason: 'unexpected notification body',);

    /*
    Each notification that leaves the app and given to the device need to
    have an id to identify it. The notification id is used to identify the
    notification when it is sent to the device.
     */
    final expectedNotificationId =
        '$expectedOrderId${NotificationType.reminder}'.hashCode;
    expect(notification.notificationId, expectedNotificationId,
        reason: 'unexpected notification id',);

    /*
    A reminder notification should appear 1 hour before the start of the event
    in the test the start date has 2 hours so the notification date should
    be 1 hour
     */
    /*expect(notification.createdAt.hour, 1,
        reason: 'unexpected notification date',);*/

    //The seen value refers to if the user has seen the notification
    //the new notification should not have been seen by the user
    expect(notification.seen, false,
        reason: 'unexpected notification seen value',);

    expect(notification.type, NotificationType.reminder,
        reason: 'unexpected notification type',);

    //try to add another notification
  });

  test('create rating notification test', () async {

    final notificationDatabase = NotificationDatabase(database: database);
    final notificationHandler = NotificationHandler(
      notificationDatabase: notificationDatabase,
      notificationSettings: MockNotificationSettings(),
    );

    const expectedOrderId = '1';
    const expectedOrderTitle = 'title';
    final expectedStartTime = DateTime(2020, 1, 1, 2);
    await notificationHandler.createRatingNotification(
      expectedOrderId,
      expectedOrderTitle,
      expectedStartTime,);

    /*
    The app should only create a rating notification once
    to avoid the possibility of the user getting duplicates of
    notifications that they have already seen.
     */
    const unexpectedOrderTitle = 'title1';
    await notificationHandler.createRatingNotification(
      expectedOrderId,
      unexpectedOrderTitle,
      expectedStartTime,);

    final notifications = await notificationDatabase
        .getNotificationsByOrder(expectedOrderId);

    expect(notifications, isNotEmpty,
      reason: 'notification list unexpectedly empty',);

    //check that the notification was not duplicated
    expect(notifications.length, 1,
        reason: 'unexpected notification list length',);

    final notification = notifications.first;

    expect(notification.order, expectedOrderId, reason: 'unexpected order id');
    const expectedNotificationBody =
        'How do you rate your time at $expectedOrderTitle';
    expect(notification.body, expectedNotificationBody,
      reason: 'unexpected notification body',);

    /*
    Each notification that leaves the app and given to the device need to
    have an id to identify it. The notification id is used to identify the
    notification when it is sent to the device.
     */
    final expectedNotificationId =
        '$expectedOrderId${NotificationType.rate}'.hashCode;
    expect(notification.notificationId, expectedNotificationId,
      reason: 'unexpected notification id',);

    /*
    A rating notification should appear 12 hours after the end of the event
    in the test the start date has 2 hours so the notification date should
    be 14 hour
     */
    /*expect(notification.createdAt.hour, 14,
      reason: 'unexpected notification date',);*/

    //The seen value refers to if the user has seen the notification
    //the new notification should not have been seen by the user
    expect(notification.seen, false,
      reason: 'unexpected notification seen value',);

    expect(notification.type, NotificationType.rate,
      reason: 'unexpected notification type',);

  });

}

class MockNotificationSettings implements NotificationSettingsInterface {
  @override
  Future<bool> getAllowedNotificationsOption() async {
    return false;
  }

  @override
  Future<bool> getOnlyUpdatesOption() async {
    return false;
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {

  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {

  }

}
