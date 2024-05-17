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
        ref.read(notificationScreenNotifierProvider.notifier).addNotification();
      }, child: const Icon(Icons.add),),
      bottomNavigationBar: const AppNavigationBar(currentScreen: 0,),
    );
  }
}
