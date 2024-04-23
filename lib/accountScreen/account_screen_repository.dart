import 'package:gigantic_ticket_wallet/database/account_database.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';

///
class AccountScreenRepository extends AccountScreenRepositoryInterface{
  /// constructor
  AccountScreenRepository({
    required LoginDatabaseInterface loginDatabase,
    required AccountDatabaseInterface database,
  }) : _loginDatabase = loginDatabase, _database = database;

  final LoginDatabaseInterface _loginDatabase;
  final AccountDatabaseInterface _database;

  @override
  Future<void> logout() async {
    await _loginDatabase.logout();
  }

  @override
  Future<bool> getAllowedNotificationsOption() {
    return _database.getAllowedNotificationsOption();
  }

  @override
  Future<bool> getOnlyUpdatesOption() {
    return _database.getOnlyUpdatesOption();
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) {
    return _database.setAllowAllNotificationsOption(isAllowed: isAllowed);
  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) {
    return _database.setOnlyUpdatesOption(isAllowed: isAllowed);
  }
}

///
abstract class AccountScreenRepositoryInterface {
  /// log user out
  Future<void> logout();

  /// get all notifications option
  Future<bool> getAllowedNotificationsOption();

  /// save all notification option
  Future<void> setAllowAllNotificationsOption({required bool isAllowed});

  // only updates references notifications like event delayed
  /// get only updates option
  Future<bool> getOnlyUpdatesOption();

  /// save only updates option
  Future<void> setOnlyUpdatesOption({required bool isAllowed});
}
