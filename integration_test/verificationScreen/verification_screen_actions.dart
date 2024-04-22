import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils/test_utils.dart';

class VerificationScreenActions {

  static Future<void> test(PatrolIntegrationTester $) async {
    await _toVerificationScreen($);

    await _verifyWithNoInternetConnection($);

    await _verifyWithNoVerificationCode($);

    await _verifyWithIncorrectVerificationCode($);

    //go back to login screen
    await $.native.pressBack();
  }

  static Future<void> _toVerificationScreen(PatrolIntegrationTester $) async {
    //at this point the user should be on the login screen. This action
    //will get them to the verification screen.

    await $.pump();

    await $(#userNameKey).enterText('test@gigantic.com');

    await $('Forgotten your password?').tap();

    /**
     * pumpAndSettle timed out
     * This is often caused by the app running an animation
     * during the test.
     * To resolve this use just pump
     */
    await $.pump();
  }

  static Future<void> _verifyWithNoInternetConnection(PatrolIntegrationTester $)
  async {

    await TestingUtils.internetDisconnect($);

    await $(#verificationCodeKey).enterText('999111');

    await $(#loginButtonKey).tap();

    //wait as the app calls the api
    await Future<void>.delayed(const Duration(seconds: 2));

    await $.pump();

    const expectedErrorMessage =
        'This device is not connected to the internet. \nPlease try again.';

    expect(
      $(expectedErrorMessage),
      findsOneWidget,
      reason: 'unable to find error container with expected error message',
    );

    await TestingUtils.internetConnect($);
  }

  static Future<void> _verifyWithNoVerificationCode(PatrolIntegrationTester $)
  async {

    await $(#loginButtonKey).tap();

    //wait as the app calls the api
    await Future<void>.delayed(const Duration(seconds: 2));

    await $.pump();

    const expectedErrorMessage =
        'The verification code is empty. \nPlease try again.';

    expect(
      $(expectedErrorMessage),
      findsOneWidget,
      reason: 'unable to find error container with expected error message',
    );
  }

  //TODO when the app has a log out function uncomment this action
  /*
  static Future<void> _verifyWithValidVerificationCode(PatrolIntegrationTester $) async {
    await $(#verificationCodeKey).enterText('999111');

    await $(#loginButtonKey).tap();

    //wait as the app calls the api
    await Future<void>.delayed(const Duration(seconds: 2));

    await $.pump();
  }*/

  static Future<void> _verifyWithIncorrectVerificationCode(PatrolIntegrationTester $) async {
    await $(#verificationCodeKey).enterText('999000');

    await $(#loginButtonKey).tap();

    //wait as the app calls the api
    await Future<void>.delayed(const Duration(seconds: 2));

    await $.pump();

    const expectedErrorMessage =
        "This code don't match our records or may have expired. \nPlease try again";

    expect(
      $(expectedErrorMessage),
      findsOneWidget,
      reason: 'unable to find error container with expected error message',
    );
  }

}
