import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// app settings related to notifications
class NotificationSettings implements NotificationSettingsInterface {
  static const _allNotificationsOptionKey = 'allNotificationsKey';
  static const _onlyUpdatesOptionKey = 'onlyUpdatesKey';

  /// get all notifications option
  @override
  Future<bool> getAllowedNotificationsOption() async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    final isAllowed = prefs.getBool(_allNotificationsOptionKey) ?? true;
    return isAllowed;
  }

  // only updates references notifications like event delayed
  /// get only updates option
  @override
  Future<bool> getOnlyUpdatesOption() async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    final isAllowed = prefs.getBool(_onlyUpdatesOptionKey) ?? true;
    return isAllowed;
  }

  /// save all notification option
  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed})
  async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(_allNotificationsOptionKey, isAllowed);
  }

  /// save only updates option
  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(_onlyUpdatesOptionKey, isAllowed);
  }

}

///
abstract class NotificationSettingsInterface {
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
