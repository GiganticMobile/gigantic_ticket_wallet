import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_settings.dart';

///
class AccountScreenRepository extends AccountScreenRepositoryInterface{
  /// constructor
  AccountScreenRepository({
    required LoginDatabaseInterface loginDatabase,
  }) : _loginDatabase = loginDatabase;

  final LoginDatabaseInterface _loginDatabase;

  @override
  Future<void> logout() async {
    await _loginDatabase.logout();
  }

  @override
  Future<bool> getAllowedNotificationsOption() {
    return NotificationSettings.getAllowedNotificationsOption();
  }

  @override
  Future<bool> getOnlyUpdatesOption() {
    return NotificationSettings.getOnlyUpdatesOption();
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {
    if (isAllowed) {
      await NotificationSettings
          .setAllowAllNotificationsOption(isAllowed: isAllowed);
      await NotificationSettings
          .setOnlyUpdatesOption(isAllowed: isAllowed);
    } else {
      await NotificationSettings
          .setAllowAllNotificationsOption(isAllowed: isAllowed);
    }
  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) {
    return NotificationSettings.setOnlyUpdatesOption(isAllowed: isAllowed);
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
