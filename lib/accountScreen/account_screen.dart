import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// this provides the user with a list of settings
class AccountScreen extends StatelessWidget {
  /// constructor
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(children: const [
              ListTile(title: Text('Account screen'),),
            ],),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: 2,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: 'Notifications',),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.event),
                      label: 'Orders',),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_box),
                      label: 'Account',),
                ],
                onTap: (index) {
                  switch(index) {
                    case 0:
                      context.push('/Notification');
                    case 1:
                      context.push('/Order');
                    case 2:
                      context.push('/Account');
                  }
                },
            ),
        ),
    );
  }
}
