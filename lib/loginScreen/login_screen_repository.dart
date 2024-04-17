import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_result.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';

/// this handles the business logic of the login screen
class LoginScreenRepository extends LoginScreenRepositoryInterface {

  /// constructor
  LoginScreenRepository({
    required LoginAPIInterface api,
    required LoginDatabaseInterface database,}) {
    _api = api;
    _database = database;
  }
  late final LoginAPIInterface _api;
  late final LoginDatabaseInterface _database;

  @override
  Future<LoginResult> login(String email, String password) async {
    if (email.isEmpty == true || password.isEmpty == true) {
      return LoginResult.emptyInput;
    }

    final result = await _api.login(email, password);

    if (result == null) {
      return LoginResult.wrongInput;
    } else {
      await _database.setLoggedInTime();
      return LoginResult.success;
    }
  }

}

///
abstract class LoginScreenRepositoryInterface {

  /// handle login business logic
  Future<LoginResult> login(String email, String password);
  
}
