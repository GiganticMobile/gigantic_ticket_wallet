import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/accountScreen/account_screen_notifier.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// this provides the user with a list of settings
class AccountScreen extends StatelessWidget {
  /// constructor
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(children: [
              const NotificationSettings(),
              ListTile(
                leading: const Icon(Icons.gavel),
                title: const Text('Terms and conditions'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy issue'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Contact customer Services'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final url = Uri.tryParse('https://www.gigantic.com/help');
                  if (url != null) {
                    launchUrl(url);
                  }
                },
              ),
              const LogoutButton(),
            ],),
            bottomNavigationBar: const AppNavigationBar(currentScreen: 2,),
        ),
    );
  }
}

///
class NotificationSettings extends ConsumerStatefulWidget {
  /// constructor
  const NotificationSettings({super.key,});

  @override
  NotificationSettingsState createState() => NotificationSettingsState();
}

///
class NotificationSettingsState extends ConsumerState<NotificationSettings> {

  bool _allowAllNotifications = false;
  bool _allowOnlyUpdates = false;

  @override
  void initState() {
    ref.read(accountScreenNotifierProvider.notifier)
        .getAllowedNotificationsOption().then((value) {
      setState(() {
        _allowAllNotifications = value;
      });
    });
    ref.read(accountScreenNotifierProvider.notifier)
        .getOnlyUpdatesOption().then((value) {
      _allowOnlyUpdates = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.notifications),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Push notification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,),
                      textAlign: TextAlign.start,),
                    Switch(value: _allowAllNotifications, onChanged: (value) {
                      setState(() {
                        _allowAllNotifications = value;
                        if (value) {
                          _allowOnlyUpdates = value;
                        }
                        ref.read(accountScreenNotifierProvider.notifier)
                            .setAllowAllNotificationsOption(isAllowed: value);
                      });
                    },),
                  ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 250,
                      child: Text('Receive updates about when your tickets are '
                          'available, updates to your event '
                          'and venue information.',
                        textAlign: TextAlign.start,),
                    ),
                    Switch(value: _allowOnlyUpdates, onChanged: (value) {
                      setState(() {
                        _allowOnlyUpdates = value;
                        ref.read(accountScreenNotifierProvider.notifier)
                            .setOnlyUpdatesOption(isAllowed: value);
                      });
                    },),
                  ],),
              ],
            ),
          ),
        ],);
  }
}

///
class LogoutButton extends ConsumerWidget {
  ///
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Log out'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        ref.read(accountScreenNotifierProvider.notifier).logout().then((value) {
          context.go('/');
        });
      },
    );
  }
}
