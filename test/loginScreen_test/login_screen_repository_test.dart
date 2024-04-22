import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_result.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_repository.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';
import 'package:gigantic_ticket_wallet/network/model/login_result.dart' as network;
import 'package:gigantic_ticket_wallet/utils/connection_utils.dart';
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

  test('successful login test', () async {

    final api = MockLoginApi(loginResult: network.LoginResult('', 0));

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = LoginScreenRepository(
        api: api,
        database: database,
        connectionUtils: connectionUtils,);

    final loginResult = await repository.login('test@test.com', '000000');

    expect(loginResult, LoginResult.success, reason: 'unexpected login result');

    //check the repository added a value to the database
    final isLoggedIn = await database.isAlreadyLoggedIn();

    // since the repository logged in successfully means that the app
    // should have set the logged in time. So the database should return the
    //is already logged in value of true.
    expect(isLoggedIn, true, reason: 'unexpected already logged in value');
  });

  test('username and password check login test', () async {
    /*
    This checks that if the user name, password or both are empty
    then the repository will fail to log the user in.
     */

    final api = MockLoginApi(loginResult: network.LoginResult('', 0));

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = LoginScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    // empty user name and full password
    var result = await repository.login('', '000000');

    expect(result, LoginResult.emptyInput, reason: 'unexpected login result');

    // full user name and empty password
    result = await repository.login('test@test.com', '');

    expect(result, LoginResult.emptyInput, reason: 'unexpected login result');

    // empty user name and empty password
    result = await repository.login('', '');

    expect(result, LoginResult.emptyInput, reason: 'unexpected login result');

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully log the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');

  });

  test('no connection login test', () async {
    /*
    this check that the repository fails to log the user in
    if there is no internet connection.
     */

    final api = MockLoginApi(loginResult: network.LoginResult('', 0));

    final database = LoginDatabase(prefs: prefs);

    //no internet connection
    final connectionUtils = MockConnectionUtils(connected: false);

    final repository = LoginScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    final result = await repository.login('test@test.com', '000000');

    expect(result, LoginResult.noConnectedError,
        reason: 'unexpected login result',);

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully log the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');
  });

  test('api returns bad log in response login test', () async {
    //the api will return null as a result which means the response
    //from the api was not successful.
    final api = MockLoginApi();

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = LoginScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    final result = await repository.login('test@test.com', '000000');

    expect(result, LoginResult.wrongInput,
      reason: 'unexpected login result',);

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully log the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');
  });
}

class MockLoginApi extends LoginAPIInterface {
  MockLoginApi({network.LoginResult? loginResult}) : _loginResult = loginResult;

  final network.LoginResult? _loginResult;

  @override
  Future<network.LoginResult?> login(String email, String password) async {
    return _loginResult;
  }

}

class MockConnectionUtils extends ConnectionUtilsInterface {
  MockConnectionUtils({required bool connected}) : _connected = connected;

  final bool _connected;

  @override
  Future<bool> hasInternetConnection() async {
    return _connected;
  }

}
