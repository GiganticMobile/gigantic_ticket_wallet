import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });
  tearDown(() async {
    await prefs.clear();

  });

  test('check is already logged in test', () async {

    final database = LoginDatabase(prefs: prefs);

    await database.setLoggedInTime();

    /*
    Since the login time was set moments before the isAlreadyLoggedIn is
    called means the the logged in time is not null and the login time
    has not expired. As a result is already logged in should be true.
     */
    final result = await database.isAlreadyLoggedIn();

    expect(result, true, reason: 'unexpected already logged in value');

  });

  test('check not already logged in value set test', () async {
    /*
    Since the already scanned value has not been set then the
    the database should return with the default value of false.
     */

    final database = LoginDatabase(prefs: prefs);

    final result = await database.isAlreadyLoggedIn();

    expect(result, false, reason: 'unexpected already logged in value');

  });

  test('check is already logged in expired test', () async {

    // test last log in time which is 4 minutes ago
    final lastLoggedInTime = DateTime.now()
        .subtract(const Duration(minutes: 4))
        .millisecondsSinceEpoch;
    //because of this the login time should have expired
    // and already logged in should be false.

    await prefs.setInt('loginDateKey', lastLoggedInTime);

    final database = LoginDatabase(prefs: prefs);

    final result = await database.isAlreadyLoggedIn();

    expect(result, false, reason: 'unexpected already logged in value');
  });
}
