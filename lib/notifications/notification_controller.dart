import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:gigantic_ticket_wallet/main.dart';
import 'package:go_router/go_router.dart';

///this handles the events that occur on the notifications sent to the device
class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future <void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification,) async {
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma('vm:entry-point')
  static Future <void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification,) async {
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma('vm:entry-point')
  static Future <void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction,) async {
  }

  /// Use this method to detect when the user taps on a notification or button
  @pragma('vm:entry-point')
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction)
  async {
    await MyApp.navigatorKey.currentContext?.push('/Notification');
  }
}