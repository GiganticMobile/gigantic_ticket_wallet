import 'package:shared_preferences/shared_preferences.dart';

///this handles all the users settings
class AccountDatabase extends AccountDatabaseInterface {
  /// constructor
  AccountDatabase({required SharedPreferences prefs}) :
        _prefs = prefs;

  final SharedPreferences _prefs;

  final _allNotificationsOptionKey = 'allNotificationsKey';
  final _onlyUpdatesOptionKey = 'onlyUpdatesKey';

  @override
  Future<bool> getAllowedNotificationsOption() async {
    final isAllowed = _prefs.getBool(_allNotificationsOptionKey) ?? true;
    return isAllowed;
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {
    await _prefs.setBool(_allNotificationsOptionKey, isAllowed);
  }

  @override
  Future<bool> getOnlyUpdatesOption() async {
    final isAllowed = _prefs.getBool(_onlyUpdatesOptionKey) ?? true;
    return isAllowed;
  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {
    await _prefs.setBool(_onlyUpdatesOptionKey, isAllowed);
  }

}

///
abstract class AccountDatabaseInterface {

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
