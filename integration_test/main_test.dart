import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/accountScreen/account_screen_repository.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_repository.dart';
import 'package:gigantic_ticket_wallet/main.dart' as app;
import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_handler.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_screen_repository.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen_repository.dart';
import 'package:gigantic_ticket_wallet/utils/connection_utils.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen_repository.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_api_data/mock_login_endpoints.dart';
import 'mock_api_data/mock_order_endpoints.dart';
import 'mock_api_data/mock_verification_endpoints.dart';

void main() {

  setupTestDependencyInjection();

  //This is here as if the orientation changes in a away not accounted for by
  // the test then the test might fail.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: app.MyApp()));

}

/// dependency injection setup using get it
void setupTestDependencyInjection() {

  //database
  GetIt.I.registerLazySingletonAsync<SharedPreferences>(
    SharedPreferences.getInstance,);
  GetIt.I.registerLazySingletonAsync<LoginDatabaseInterface>(() async {
    await GetIt.I.isReady<SharedPreferences>();

    final sharedPreferences = GetIt.I.get<SharedPreferences>();

    return LoginDatabase(prefs: sharedPreferences);
  });

  GetIt.I.registerLazySingleton<AppDatabase>(AppDatabase.createDatabase);
  GetIt.I.registerLazySingleton<OrderDatabaseInterface>(() {
    final database = GetIt.I.get<AppDatabase>();
    return OrderDatabase(database: database);
  });
  GetIt.I.registerLazySingleton<EventDatabaseInterface>(() {
    final database = GetIt.I.get<AppDatabase>();
    return EventDatabase(database: database);
  });
  GetIt.I.registerLazySingleton<TicketDatabaseInterface>(() {
    final database = GetIt.I.get<AppDatabase>();
    return TicketDatabase(database: database);
  });
  GetIt.I.registerLazySingleton<NotificationDatabaseInterface>(() {
    final database = GetIt.I.get<AppDatabase>();
    return NotificationDatabase(database: database);
  });

  //login api
  GetIt.I.registerLazySingleton<LoginEndPointsInterface>(
      MockLoginEndPoints.new,);
  GetIt.I.registerLazySingleton<LoginAPIInterface>(() {
    final endPoints = GetIt.I.get<LoginEndPointsInterface>();
    return LoginAPI(endPoints: endPoints);
  });

  //verification api
  GetIt.I.registerLazySingleton<VerificationEndPointsInterface>(
    MockVerificationEndPoints.new,);
  GetIt.I.registerLazySingleton<VerificationAPIInterface>(() {
    final endPoints = GetIt.I.get<VerificationEndPointsInterface>();
    return VerificationAPI(endPoints: endPoints);
  });

  //order api
  GetIt.I.registerLazySingleton<OrderEndPointsInterface>(
      MockOrderEndPoints.new,);
  GetIt.I.registerLazySingleton<OrderAPIInterface>(() {
    final endPoints = GetIt.I.get<OrderEndPointsInterface>();
    return OrderAPI(endPoints: endPoints);
  });

  //notifications
  GetIt.I.registerLazySingleton<NotificationHandler>(() {
    final notificationDatabase = GetIt.I.get<NotificationDatabaseInterface>();
    return NotificationHandler(notificationDatabase: notificationDatabase);
  });

  //app repositories
  GetIt.I.registerLazySingletonAsync<AccountScreenRepositoryInterface>(() async {
    await GetIt.I.isReady<LoginDatabaseInterface>();
    final loginDatabase = GetIt.I.get<LoginDatabaseInterface>();

    return AccountScreenRepository(
      loginDatabase: loginDatabase,);
  });

  GetIt.I.registerLazySingletonAsync<LoginScreenRepositoryInterface>(() async {

    final api = GetIt.I.get<LoginAPIInterface>();

    await GetIt.I.isReady<LoginDatabaseInterface>();
    final database = GetIt.I.get<LoginDatabaseInterface>();
    final connectionUtils = GetIt.I.get<ConnectionUtilsInterface>();

    return LoginScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);
  });

  GetIt.I.registerLazySingletonAsync<VerificationScreenRepositoryInterface>(
          () async {
        final api = GetIt.I.get<VerificationAPIInterface>();

        await GetIt.I.isReady<LoginDatabaseInterface>();
        final database = GetIt.I.get<LoginDatabaseInterface>();
        final connectionUtils = GetIt.I.get<ConnectionUtilsInterface>();

        return VerificationScreenRepository(
          api: api,
          database: database,
          connectionUtils: connectionUtils,);
      });

  GetIt.I.registerLazySingleton<SyncScreenRepositoryInterface>(() {
    final api = GetIt.I.get<OrderAPIInterface>();
    final orderDatabase = GetIt.I.get<OrderDatabaseInterface>();
    final eventDatabase = GetIt.I.get<EventDatabaseInterface>();
    final ticketDatabase = GetIt.I.get<TicketDatabaseInterface>();
    final notificationHandler = GetIt.I.get<NotificationHandler>();

    return SyncScreenRepository(
      api: api,
      orderDatabase: orderDatabase,
      eventDatabase: eventDatabase,
      ticketDatabase: ticketDatabase,
      notificationHandler: notificationHandler,
    );
  });

  GetIt.I.registerLazySingleton<OrderScreenRepositoryInterface>(() {
    final orderDatabase = GetIt.I.get<OrderDatabaseInterface>();
    final eventDatabase = GetIt.I.get<EventDatabaseInterface>();
    return OrderScreenRepository(
        orderDatabase: orderDatabase,
        eventDatabase: eventDatabase,);
  });

  //utils
  GetIt.I.registerLazySingleton(() {
    return InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse('https://www.gigantic.com/wallet_app/login.php?'),
        ),
      ],
    );
  });
  GetIt.I.registerLazySingleton<ConnectionUtilsInterface>(() {
    final internetConnection = GetIt.I.get<InternetConnection>();
    return ConnectionUtils(internetConnection: internetConnection);
  });
}
