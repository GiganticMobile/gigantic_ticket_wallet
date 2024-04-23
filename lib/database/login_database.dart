import 'package:shared_preferences/shared_preferences.dart';

/*
example shared preferences test for future reference
test('Can Create Preferences', () async{

    SharedPreferences.setMockInitialValues({}); //set values here
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool working = false;
    String name = 'john';
    pref.setBool('working', working);
    pref.setString('name', name);


    expect(pref.getBool('working'), false);
    expect(pref.getString('name'), 'john');
  });
 */

/// This handles the interaction between the app and the login information
/// stored in the database
class LoginDatabase extends LoginDatabaseInterface {

  /// constructor
  LoginDatabase({required SharedPreferences prefs}) :
    _prefs = prefs;

  /*
  static Future<LoginDatabase> create() async {
    await GetIt.I.isReady<SharedPreferences>();

    final sharedPreferences = GetIt.I.get<SharedPreferences>();

    return LoginDatabase(prefs: sharedPreferences);
  }*/

  final SharedPreferences _prefs;

  final _loginDateKey = 'loginDateKey';

  final _loginTime = const Duration(minutes: 3);

  @override
  Future<bool> isAlreadyLoggedIn() async {
    /*
    Here shared preferences are used. This is because shared preferences
    can be faster that looking through a database. This is important
    as in the main.dart the app checks if the user is logged in
    and every time they go to a new screen.
    Shared preferences is only used here as it is only good for accessing
    small amounts of information quickly.
     */
    final loginDateInMilliSecs = _prefs.getInt(_loginDateKey);

    if (loginDateInMilliSecs == null) {
      return false;
    } else {
      final currentTime = DateTime.now();
      final loginDate = DateTime
          .fromMillisecondsSinceEpoch(loginDateInMilliSecs);

      final difference = currentTime.difference(loginDate);

      //last login happened more than login time ago
      if (difference.compareTo(_loginTime) > 0) {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  Future<void> setLoggedInTime() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await _prefs.setInt(_loginDateKey, currentTime);
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_loginDateKey);
  }
}

///
abstract class LoginDatabaseInterface {

  /// check if the user has been logged in for too long
  Future<bool> isAlreadyLoggedIn();

  /// set login time
  Future<void> setLoggedInTime();

  /// log user out
  Future<void> logout();
}
