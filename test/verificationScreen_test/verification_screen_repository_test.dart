import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
import 'package:gigantic_ticket_wallet/utils/connection_utils.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_result.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen_repository.dart';
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

  test('successful verification test', () async {

    final api = MockVerificationAPI(isSuccessful: true);

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = VerificationScreenRepository(
        api: api,
        database: database,
        connectionUtils: connectionUtils,);

    final result = await repository.verify('test@test.com', '123456');

    expect(result, VerificationResult.success,
        reason: 'unexpected verification result',);

    //check the repository added a value to the database
    final isLoggedIn = await database.isAlreadyLoggedIn();

    // since the repository logged in successfully means that the app
    // should have set the logged in time. So the database should return the
    //is already logged in value of true.
    expect(isLoggedIn, true, reason: 'unexpected already logged in value');

  });

  test('no username or verification code test', () async {
    /*
    This checks that if the user name, verification or both are empty
    then the repository will fail to verify the user in.
     */
    final api = MockVerificationAPI(isSuccessful: true);

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = VerificationScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    //full user name and empty verification code
    var result = await repository.verify('test@test.com', '');

    expect(result, VerificationResult.emptyInput,
        reason: 'unexpected verification result',);

    //empty user name and full verification code
    result = await repository.verify('', '123456');

    expect(result, VerificationResult.emptyInput,
      reason: 'unexpected verification result',);

    //empty user name and empty verification code
    result = await repository.verify('', '');

    expect(result, VerificationResult.emptyInput,
      reason: 'unexpected verification result',);

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully verify the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');
  });

  test('no connection verification test', () async {
    /*
    this check that the repository fails to verify the user
    if there is no internet connection.
     */
    final api = MockVerificationAPI(isSuccessful: true);

    final database = LoginDatabase(prefs: prefs);

    //no internet connection
    final connectionUtils = MockConnectionUtils(connected: false);

    final repository = VerificationScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    final result = await repository.verify('test@test.com', '123456');

    expect(result, VerificationResult.noConnectedError,
      reason: 'unexpected verification result',);

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully verify the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');
  });

  test('api return bad response verification test', () async {
    final api = MockVerificationAPI(isSuccessful: false);

    final database = LoginDatabase(prefs: prefs);

    final connectionUtils = MockConnectionUtils(connected: true);

    final repository = VerificationScreenRepository(
      api: api,
      database: database,
      connectionUtils: connectionUtils,);

    final result = await repository.verify('test@test.com', '123456');

    expect(result, VerificationResult.wrongInput,
        reason: 'unexpected verification result',);

    final isLoggedIn = await database.isAlreadyLoggedIn();

    //since the repository did not successfully verify the user in
    // as a result the is Logged in value should be false
    expect(isLoggedIn, false, reason: 'unexpected already logged in value');
  });

}

class MockVerificationAPI extends VerificationAPIInterface {
  MockVerificationAPI({required bool isSuccessful})
      : _isSuccessful = isSuccessful;
  final bool _isSuccessful;
  @override
  Future<bool> verify(String email, String code) async {
    return _isSuccessful;
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
