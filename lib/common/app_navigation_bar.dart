import 'package:flutter/material.dart';
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
      items: [
        BottomNavigationBarItem(
          icon: Stack(children: [
            const Icon(Icons.notifications),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),),
            ),
          ],),
          label: 'Notifications',),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Orders',),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Account',),
      ],
      onTap: (index) {
        if (index != 1) {
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
