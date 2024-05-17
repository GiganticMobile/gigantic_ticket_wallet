import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar.dart';
import 'package:gigantic_ticket_wallet/notificationScreen/notification_screen_notifier.dart';

/// this provides a list of notifications
class NotificationScreen extends StatelessWidget {
  /// constructor
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: NotificationList(),
    );
  }
}

///
class NotificationList extends ConsumerStatefulWidget {
  ///constructor
  const NotificationList({super.key});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(notificationScreenNotifierProvider.notifier).getNotifications();
      ref.read(notificationScreenNotifierProvider.notifier)
          .setAllNotificationsAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(notificationScreenNotifierProvider);

    return Scaffold(
      body: ListView.builder(
          itemCount: state.valueOrNull?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.valueOrNull?[index].title ?? ''),);
      },),
      floatingActionButton: FloatingActionButton(onPressed: () {

        AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
          if (!isAllowed) {
            // This is just a basic example. For real apps, you must show some
            // friendly dialog box before call the request method.
            // This is very important to not harm the user experience
            AwesomeNotifications().requestPermissionToSendNotifications();
          } else {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 10,
                  channelKey: 'basic_channel',
                  title: 'Wait 5 seconds to show',
                  body: 'Now it is 5 seconds later.',
                  category: NotificationCategory.Reminder,
                  wakeUpScreen: true,
                ),
                schedule: NotificationCalendar.fromDate(
                    date: DateTime.now().add(const Duration(minutes: 1)),),
            );
          }
        });

        ref.read(notificationScreenNotifierProvider.notifier).addNotification();
      }, child: const Icon(Icons.add),),
      bottomNavigationBar: const AppNavigationBar(currentScreen: 0,),
    );
  }
}
