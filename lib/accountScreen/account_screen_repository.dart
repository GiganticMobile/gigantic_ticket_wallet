import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_settings.dart';

///
class AccountScreenRepository implements AccountScreenRepositoryInterface{
  /// constructor
  AccountScreenRepository({
    required LoginDatabaseInterface loginDatabase,
    required NotificationSettingsInterface notificationSettings,
  }) : _loginDatabase = loginDatabase, _notificationSettings = notificationSettings;

  final LoginDatabaseInterface _loginDatabase;
  final NotificationSettingsInterface _notificationSettings;

  @override
  Future<void> logout() async {
    await _loginDatabase.logout();
  }

  @override
  Future<bool> getAllowedNotificationsOption() {
    return _notificationSettings.getAllowedNotificationsOption();
  }

  @override
  Future<bool> getOnlyUpdatesOption() {
    return _notificationSettings.getOnlyUpdatesOption();
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {
    if (isAllowed) {
      await _notificationSettings
          .setAllowAllNotificationsOption(isAllowed: isAllowed);
      await _notificationSettings
          .setOnlyUpdatesOption(isAllowed: isAllowed);
    } else {
      await _notificationSettings
          .setAllowAllNotificationsOption(isAllowed: isAllowed);
    }
  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) {
    return _notificationSettings.setOnlyUpdatesOption(isAllowed: isAllowed);
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
