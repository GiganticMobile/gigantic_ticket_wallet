import 'package:flutter/material.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar.dart';

/// this provides a list of notifications
class NotificationScreen extends StatelessWidget {
  /// constructor
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(children: const [
          ListTile(title: Text('Notification screen'),),
        ],),
        bottomNavigationBar: const AppNavigationBar(currentScreen: 0,),
      ),
    );
  }
}
