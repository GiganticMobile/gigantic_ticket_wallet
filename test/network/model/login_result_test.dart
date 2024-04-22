import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/login_result.dart';

void main() {

  test('create from json login result test', () {

    const expectedEmail = 'test@gigantic.com';
    const expectedTimeStamp = 1713780103;
    final json = {
      'data': {
        'email_address': expectedEmail,
        'login_timestamp': expectedTimeStamp,
      },
      'message': 'Login successful with auth code',
      'status': 'LOGIN SUCCESSFUL',
    };

    final loginResult = LoginResult.fromJson(json);

    expect(loginResult.email, expectedEmail,
        reason: 'unexpected login result email');
    expect(loginResult.timeStamp, expectedTimeStamp,
        reason: 'unexpected login result time stamp');

  });
}
