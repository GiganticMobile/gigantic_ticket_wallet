import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_repository.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen_repository.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// dependency injection setup using get it
void setupDependencyInjection() {

  //database
  GetIt.I.registerLazySingletonAsync<SharedPreferences>(
      SharedPreferences.getInstance,);
  GetIt.I.registerLazySingletonAsync<LoginDatabaseInterface>(() async {
    await GetIt.I.isReady<SharedPreferences>();

    final sharedPreferences = GetIt.I.get<SharedPreferences>();

    return LoginDatabase(prefs: sharedPreferences);
  });
  GetIt.I.registerLazySingleton<AppDatabase>(AppDatabase.new);
  GetIt.I.registerLazySingleton<OrderDatabaseInterface>(OrderDatabase.new);
  GetIt.I.registerLazySingleton<TicketDatabaseInterface>(TicketDatabase.new);

  //login api
  GetIt.I.registerLazySingleton<LoginEndPointsInterface>(
    LoginEndPoints.new,);
  GetIt.I.registerLazySingleton<LoginAPIInterface>(() {
    final endPoints = GetIt.I.get<LoginEndPointsInterface>();
    return LoginAPI(endPoints: endPoints);
  });

  //verification api
  GetIt.I.registerLazySingleton<VerificationEndPointsInterface>(
      VerificationEndPoints.new,);
  GetIt.I.registerLazySingleton<VerificationAPIInterface>(() {
    final endPoints = GetIt.I.get<VerificationEndPointsInterface>();
    return VerificationAPI(endPoints: endPoints);
  });

  //order api
  GetIt.I.registerLazySingleton<OrderEndPointsInterface>(OrderEndPoints.new);
  GetIt.I.registerLazySingleton<OrderAPIInterface>(() {
    final endPoints = GetIt.I.get<OrderEndPointsInterface>();
    return OrderAPI(endPoints: endPoints);
  });

  //app repositories
  GetIt.I.registerLazySingletonAsync<LoginScreenRepositoryInterface>(() async {

    final api = GetIt.I.get<LoginAPIInterface>();

    await GetIt.I.isReady<LoginDatabaseInterface>();
    final database = GetIt.I.get<LoginDatabaseInterface>();

    return LoginScreenRepository(api: api, database: database);
  });

  GetIt.I.registerLazySingletonAsync<VerificationScreenRepositoryInterface>(
          () async {
    final api = GetIt.I.get<VerificationAPIInterface>();

    await GetIt.I.isReady<LoginDatabaseInterface>();
    final database = GetIt.I.get<LoginDatabaseInterface>();

    return VerificationScreenRepository(api: api, database: database);
  });

  GetIt.I.registerLazySingleton<SyncScreenRepositoryInterface>(() {
    final api = GetIt.I.get<OrderAPIInterface>();
    final orderDatabase = GetIt.I.get<OrderDatabaseInterface>();
    final ticketDatabase = GetIt.I.get<TicketDatabaseInterface>();

    return SyncScreenRepository(
        api: api,
        orderDatabase: orderDatabase,
        ticketDatabase: ticketDatabase,);
  });
}
