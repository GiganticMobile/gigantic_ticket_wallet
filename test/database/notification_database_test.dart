import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/notification.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.createInMemoryDatabase();
  });
  tearDown(() async {
    await database.close();
  });

  test('Add notification', () async {

    final notificationDatabase = NotificationDatabase(database: database);

    const expectedOrderId = '1';
    const expectedNotificationId = 1;
    const expectedTitle = 'title';
    const expectedBody = 'Body';
    const expectedType = NotificationType.reminder;
    const expectedSeen = false;
    final expectedCreateAt = DateTime(2020);

    await notificationDatabase.addNotification(NotificationData(
        id: 0,
        order: expectedOrderId,
        notificationId: expectedNotificationId,
        title: expectedTitle,
        body: expectedBody,
        type: expectedType,
        seen: expectedSeen,
        createdAt: expectedCreateAt,),
    );

    final notifications = await notificationDatabase.getNotifications();

    expect(notifications, isNotEmpty,
      reason: 'notification list unexpectedly empty',);

    final notification = notifications.first;

    expect(notification.order, expectedOrderId, reason: 'unexpected order id');
    expect(notification.notificationId, expectedNotificationId,
        reason: 'unexpected notification id',);
    expect(notification.title, expectedTitle, reason: 'unexpected title');
    expect(notification.body, expectedBody, reason: 'unexpected body');
    expect(notification.type, expectedType, reason: 'unexpected type');
    expect(notification.seen, expectedSeen, reason: 'unexpected created at');

  });

  test('has unread notification test', () async {
    final notificationDatabase = NotificationDatabase(database: database);

    await notificationDatabase.addNotification(NotificationData(
      id: 0,
      order: '1',
      notificationId: 1,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: DateTime.now(),),
    );

    final hasUnread = await notificationDatabase.hasUnreadNotifications();

    expect(hasUnread, true,
        reason: 'unexpected has unread notifications value',);
  });

  test('hasUnread no notifications test', () async {
    final notificationDatabase = NotificationDatabase(database: database);

    final hasUnread = await notificationDatabase.hasUnreadNotifications();

    //since no notifications where added to the database then there
    //should be no unread notifications
    expect(hasUnread, false,
      reason: 'unexpected has unread notifications value',);
  });

  test('hasUnread only delayed notifications', () async {

    final notificationDatabase = NotificationDatabase(database: database);

    final createdAt = DateTime.now().add(const Duration(minutes: 5));

    await notificationDatabase.addNotification(NotificationData(
      id: 0,
      order: '1',
      notificationId: 1,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: createdAt,),
    );

    final hasUnread = await notificationDatabase.hasUnreadNotifications();

    /*
    The hasUnread notifications should be false because the create at
    is in the future. The create at time can be in the future as it is used
    to know when a user can see a notification. For example a reminder
    notification needs to appear at a specific time.
     */
    expect(hasUnread, false,
      reason: 'unexpected has unread notifications value',);
  });

  test('hasUnread only read notifications', () async {
    final notificationDatabase = NotificationDatabase(database: database);

    await notificationDatabase.addNotification(NotificationData(
      id: 0,
      order: '1',
      notificationId: 1,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),),
    );

    //when adding a notification to the database the seen value
    // defaults to false
    //as a result all notifications are marked as seen
    await notificationDatabase.setAllNotificationsAsRead();

    final hasUnread = await notificationDatabase.hasUnreadNotifications();

    //since the seen value is true mean that the user has seen the notification
    //then there should be no unread notifications
    expect(hasUnread, false,
      reason: 'unexpected has unread notifications value',);
  });

  test('set all notifications as read test', () async {
    final notificationDatabase = NotificationDatabase(database: database);

    final createdAt = DateTime.now().add(const Duration(minutes: 5));

    await notificationDatabase.addNotification(NotificationData(
      id: 0,
      order: '1',
      notificationId: 1,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: createdAt,),
    );

    await notificationDatabase.addNotification(NotificationData(
      id: 1,
      order: '2',
      notificationId: 2,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),),
    );

    await notificationDatabase.setAllNotificationsAsRead();

    final notifications = await notificationDatabase.getNotifications();

    final readNotifications =
    notifications.where((item) => item.seen == true).toList();

    expect(readNotifications.length, 1,
        reason: 'Unexpected Too many read notifications',);

    final readNotification = readNotifications.first;

    expect(readNotification.order, '2',
        reason: 'Unexpected read notification order id',);


  });

  test('get notifications by order test', () async {

    final notificationDatabase = NotificationDatabase(database: database);

    const expectedOrderId = '1';
    const unexpectedOrderId = '2';
    await notificationDatabase.addNotification(NotificationData(
      id: 0,
      order: expectedOrderId,
      notificationId: 1,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: DateTime.now(),),
    );

    await notificationDatabase.addNotification(NotificationData(
      id: 1,
      order: unexpectedOrderId,
      notificationId: 2,
      title: '',
      body: '',
      type: NotificationType.reminder,
      seen: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),),
    );

    final notifications =
    await notificationDatabase.getNotificationsByOrder(expectedOrderId);

    expect(notifications.length, 1,
        reason: 'unexpected notification list length',);

    expect(notifications.first.order, expectedOrderId,
        reason: 'unexpected notification order id',);
  });
}
