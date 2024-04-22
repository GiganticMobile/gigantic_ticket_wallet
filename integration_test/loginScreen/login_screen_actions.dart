import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils/test_utils.dart';

class LoginScreenActions {

  static Future<void> test(PatrolIntegrationTester $) async {

    await _loginWithoutUsernameOrPassword($);

    await _loginWithoutInternetConnection($);

    await _loginFailed($);

    await _loginSuccessful($);

  }

  static Future<void> _login(
      PatrolIntegrationTester $,
      String userName,
      String password,) async {
    await $.pumpAndSettle();

    await $(#userNameKey).enterText(userName);

    await $(#passwordKey).enterText(password);

    await $(#loginButtonKey).tap();

    await $.pumpAndSettle();
  }

  static Future<void> _loginSuccessful(PatrolIntegrationTester $) async {

    await _login($, 'test@gigantic.com', '123654');

    await Future<void>.delayed(const Duration(seconds: 2));

    await $.pumpAndSettle();

    //at ths point the user should have successfully logged in
    //and should be shown the sync screen

  }

  static Future<void> _loginWithoutUsernameOrPassword(PatrolIntegrationTester $)
  async {
    await _login($, '', '');

    //since the error container is animated the app should wait
    //until the animation completes which it should in 3 seconds
    await Future<void>.delayed(const Duration(seconds: 4));

    await $.pumpAndSettle();

    // at this point the login should fail as the app is not connected
    //to the internet as a result the user should get this error message.

    const expectedErrorMessage =
        'Either your username or password is empty. \nPlease try again.';

    expect($(expectedErrorMessage), findsOneWidget);
  }

  static Future<void> _loginWithoutInternetConnection(PatrolIntegrationTester $)
  async {
    await TestingUtils.internetDisconnect($);

    await _login($, 'test@gigantic.com', '123654');

    //since the error container is animated the app should wait
    //until the animation completes which it should in 3 seconds
    await Future<void>.delayed(const Duration(seconds: 4));

    await $.pumpAndSettle();

    // at this point the login should fail as the app is not connected
    //to the internet as a result the user should get this error message.

    const expectedErrorMessage =
        'This device is not connected to the internet. \nPlease try again.';

    expect($(expectedErrorMessage), findsOneWidget);

    await TestingUtils.internetConnect($);
  }

  static Future<void> _loginFailed(PatrolIntegrationTester $) async {

    await _login($, 'test@gigantic.com', '000000');

    //since the error container is animated the app should wait
    //until the animation completes which it should in 3 seconds
    await Future<void>.delayed(const Duration(seconds: 4));

    await $.pumpAndSettle();

    //at ths point the login should fail as the password is wrong
    // as a result the user should stay on the login screen and a
    //error warning should popup

    const expectedErrorMessage =
        "The email or password don't match our records. \nPlease try again.";

    expect($(expectedErrorMessage), findsOneWidget);

  }
}
