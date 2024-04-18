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
import 'package:go_router/go_router.dart';

void main() {
  setupDependencyInjection();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
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
class MyApp extends StatelessWidget {
  /// constructor
  const MyApp({super.key});

  // This widget is the root of your application.
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
