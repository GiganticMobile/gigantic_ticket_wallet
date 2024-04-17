import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_repository.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
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
}
