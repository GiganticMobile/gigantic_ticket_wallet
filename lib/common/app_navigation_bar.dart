import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar_notifier.dart';
import 'package:go_router/go_router.dart';

///this is the main way to navigate between the main screens of the app
class AppNavigationBar extends StatelessWidget {
  /// constructor
  const AppNavigationBar({required int currentScreen, super.key})
      : _currentScreen = currentScreen;

  final int _currentScreen;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentScreen,
      items: const [
        BottomNavigationBarItem(
          icon: Stack(children: [
            Icon(Icons.notifications),
            Positioned(
              top: 0,
              right: 0,
              child: UnreadNotificationsIcon(),
            ),
          ],),
          // this is here as when active the user will be on the notification
          //screen as a result there should be no unread notifications
          //as the user is looking at them
          activeIcon: Icon(Icons.notifications),
          label: 'Notifications',),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Orders',),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Account',),
      ],
      onTap: (index) {
        if (index != _currentScreen) {
          switch(index) {
            case 0:
              context.push('/Notification');
            case 1:
              context.push('/Order');
            case 2:
              context.push('/Account');
          }
        }
      },
    );
  }
}

///this displays a small red icon if the user has unread notifications
class UnreadNotificationsIcon extends ConsumerStatefulWidget {
  /// constructor
  const UnreadNotificationsIcon({super.key});

  @override
  _UnreadNotificationsIconState createState() =>
      _UnreadNotificationsIconState();
}

class _UnreadNotificationsIconState
    extends ConsumerState<UnreadNotificationsIcon> {

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(appNavigationBarNotifierProvider.notifier)
          .hasUnreadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(appNavigationBarNotifierProvider);

    if (state.valueOrNull ?? true) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: const BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),);
    } else {
      return const SizedBox.shrink();
    }
  }
}
