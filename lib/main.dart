import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/accountScreen/account_screen.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/dependency_injection.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen.dart';
import 'package:gigantic_ticket_wallet/notificationScreen/notification_screen.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_screen.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/view_order_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  setupDependencyInjection();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group',),
      ],
      debug: true,
  );

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  navigatorKey: MyApp.navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      redirect: (BuildContext context, GoRouterState state) async {

        //since verification is a part of login it should not be effected
        //by the auto login value.
        if (state.fullPath == '/Verification' || state.fullPath == '/Signup') {
          return null;
        }

        //redirect the user of if statement like if the user is logged in
        await GetIt.I.isReady<LoginDatabaseInterface>();

        final loginDatabase = GetIt.I.get<LoginDatabaseInterface>();
        final loggedIn = await loginDatabase.isAlreadyLoggedIn();

        if (!loggedIn) {
          return '/';
        } else {

          if (state.fullPath == '/') {
            /*
            Since the user has already logged in they don't need to see
            the login screen
             */
            return '/Sync';
            //return '/Welcome';
          }

          return null;
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'Verification',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const VerificationScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(0, 1);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        /*GoRoute(
          path: 'Signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),*/
        GoRoute(
          path: 'Order',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const OrderScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(0, 1);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: 'ViewOrder',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const ViewOrderScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(0, 1);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: 'Notification',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const NotificationScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(-1, 0);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: 'Account',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AccountScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(1, 0);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        /*GoRoute(
          path: 'QRCodeScreen',
          builder: (BuildContext context, GoRouterState state) {
            return QRCodeScreen();
          },
        ),*/
        GoRoute(
          path: 'Sync',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SyncScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(0, 1);
              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
      ],
    ),
  ],
);

/// base widget of the app
class MyApp extends StatefulWidget {
  /// constructor
  const MyApp({super.key});

  ///this is used to save the context so the context can be used
  ///when the user presses on a notification.
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    AwesomeNotifications().setListeners(
        onActionReceivedMethod:
        NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFA4C20)),
          useMaterial3: true,
        ),
      ),
    );
  }
}

///
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
