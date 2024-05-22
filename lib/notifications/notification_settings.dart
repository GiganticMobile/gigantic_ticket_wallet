
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  static const _allNotificationsOptionKey = 'allNotificationsKey';
  static const _onlyUpdatesOptionKey = 'onlyUpdatesKey';

  /// get all notifications option
  static Future<bool> getAllowedNotificationsOption() async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    final isAllowed = prefs.getBool(_allNotificationsOptionKey) ?? true;
    return isAllowed;
  }

  // only updates references notifications like event delayed
  /// get only updates option
  static Future<bool> getOnlyUpdatesOption() async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    final isAllowed = prefs.getBool(_onlyUpdatesOptionKey) ?? true;
    return isAllowed;
  }

  /// save all notification option
  static Future<void> setAllowAllNotificationsOption({required bool isAllowed})
  async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(_allNotificationsOptionKey, isAllowed);
  }

  /// save only updates option
  static Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {
    await GetIt.I.isReady<SharedPreferences>();

    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(_onlyUpdatesOptionKey, isAllowed);
  }

}

abstract class NotificationSettingsInterface {
  /// get all notifications option
  static Future<bool> getAllowedNotificationsOption() async { return false; }

  /// save all notification option
  static Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {

  }

  // only updates references notifications like event delayed
  /// get only updates option
  Future<bool> getOnlyUpdatesOption();

  /// save only updates option
  Future<void> setOnlyUpdatesOption({required bool isAllowed});
}
