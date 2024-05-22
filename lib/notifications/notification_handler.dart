
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/notification.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_controller.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_settings.dart';
import 'package:go_router/go_router.dart';

///this handles the business logic related to notifications
class NotificationHandler {

  /// constructor
  NotificationHandler({
    required NotificationDatabaseInterface notificationDatabase,
  }) : _notificationDatabase = notificationDatabase;

  final NotificationDatabaseInterface _notificationDatabase;

  static const _updatesNotificationChannel = 'updates';
  static const _generalNotificationChannel = 'general';

  /// This is used to setup the notifications for the app
  static Future<void> initialize() async {

    const updatesChannelGroupKey = 'updates_channel_group';
    const generalChannelGroupKey = 'general_channel_group';

    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: updatesChannelGroupKey,
          channelKey: _updatesNotificationChannel,
          channelName: 'Updates',
          channelDescription:
          'Allow notifications for event updates (such as event delays)',
          defaultColor: const Color(0xFFFA4C20),),
        NotificationChannel(
          channelGroupKey: generalChannelGroupKey,
          channelKey: _generalNotificationChannel,
          channelName: 'General',
          channelDescription: 'Allow notification for event news.',
          defaultColor: const Color(0xFFFA4C20),),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: updatesChannelGroupKey,
          channelGroupName: 'Updates group',),
        NotificationChannelGroup(
          channelGroupKey: generalChannelGroupKey,
          channelGroupName: 'General group',),
      ],
      debug: true,
    );
  }

  /// setup event listeners for a notification
  static void setupListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod:
      NotificationController.onActionReceivedMethod,
    );
  }

  /// check if the app has the permission to use notifications
  static Future<bool> hasPermission() async {
    return AwesomeNotifications().isNotificationAllowed();
  }

  /// ask for notification permission
  static Future<void> requestPermission(BuildContext context) async {
    await hasPermission().then((allowed) {
      if (!allowed) {
        showDialog<void>(context: context, builder: (_) {
          return AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text(
                'Get notifications on delays, event changes, reminders and event related news.'),
            actions: [
              TextButton(onPressed: () {
                _.pop();
              }, child: const Text('Deny')),

              TextButton(onPressed: () {
                AwesomeNotifications().requestPermissionToSendNotifications()
                    .then((result) {
                  if (result) {
                    //set allow all notifications in settings
                    NotificationSettings.setOnlyUpdatesOption(isAllowed: true);
                    NotificationSettings.setAllowAllNotificationsOption(
                      isAllowed: true,);
                  }
                });
                _.pop();
              }, child: const Text('Allow'),),
            ],
          );
        },);
      }
    });
  }

  Future<void> createRemindernNotification(
      String orderId,
      String orderTitle,
      DateTime oderStartTime,) async {
    final notificationsAllowed =
    await AwesomeNotifications().isNotificationAllowed();

    final existingNotifications =
    await _notificationDatabase.getNotificationsByOrder(orderId);

    //this order does not have a reminder notification
    if (existingNotifications.where(
          (item) => item.type == NotificationType.reminder,
    ).isEmpty)
    {
      final reminderId =
          '$orderId${NotificationType.reminder}'.hashCode;
      const reminderTitle = 'Event Reminder';
      final reminderBody = '$orderTitle 1 hour away';
      /// set reminder date to 1 hour before the start time
      final reminderDate = DateTime.now().add(const Duration(minutes: 1));

      final reminder = NotificationData(
        id: 0,
        order: orderId,
        notificationId: reminderId,
        title: reminderTitle,
        body: reminderBody,
        type: NotificationType.reminder,
        seen: false,
        createdAt: reminderDate,);

      await _notificationDatabase.addNotification(reminder);

      final onlyUpdates = await NotificationSettings.getOnlyUpdatesOption();
      if (notificationsAllowed && onlyUpdates) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: reminderId,
            channelKey: _updatesNotificationChannel,
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
  }

  Future<void> createRatingNotification(
      String orderId,
      String orderTitle,
      DateTime oderEndTime,) async {
    final notificationsAllowed =
    await AwesomeNotifications().isNotificationAllowed();

    final existingNotifications =
    await _notificationDatabase.getNotificationsByOrder(orderId);

    //this order does not have a rating notification
    if (existingNotifications.where(
          (item) => item.type == NotificationType.rate,
    ).isEmpty) {
      final ratingId = '$orderId${NotificationType.rate}'.hashCode;
      const ratingTitle = 'Rating';
      final ratingBody = 'How do you rate your time at $orderTitle';

      /// set rating date to 12 hours after the event
      final ratingDate = DateTime.now().add(const Duration(minutes: 2));

      final rating = NotificationData(
        id: 0,
        order: orderId,
        notificationId: ratingId,
        title: ratingTitle,
        body: ratingBody,
        type: NotificationType.rate,
        seen: false,
        createdAt: ratingDate,);

      await _notificationDatabase.addNotification(rating);

      final generalUpdates =
      await NotificationSettings.getAllowedNotificationsOption();
      if (notificationsAllowed && generalUpdates) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: ratingId,
            channelKey: _generalNotificationChannel,
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
