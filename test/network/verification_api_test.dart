import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';

void main() {

  test('successful verification api response test', () async {
    final endpoint = MockVerificationEndpoint(isSuccessful: true);
    final api = VerificationAPI(endPoints: endpoint);

    //the email and the verification code does not matter
    //as end point will return same response
    final result = await api.verify('test', 'test');

    //since the response if successful then the api should
    //return true
    expect(result, true, reason: 'unexpected verification api result');
  });

  test('failed verification api response test', () async {
    final endpoint = MockVerificationEndpoint(isSuccessful: false);
    final api = VerificationAPI(endPoints: endpoint);

    //the email and the verification code does not matter
    //as end point will return same response
    final result = await api.verify('test', 'test');

    //since the response if fails then the api should
    //return false
    expect(result, false, reason: 'unexpected verification api result');
  });

}

class MockVerificationEndpoint extends VerificationEndPointsInterface {
  MockVerificationEndpoint({required bool isSuccessful})
      : _isSuccessful = isSuccessful;
  final bool _isSuccessful;
  @override
  Future<Response<dynamic>?> verify(String email, String code) async {
    if (_isSuccessful) {
      final successJson = {
        'data': {
          'email_address': 'test@gigantic.com',
          'login_timestamp': 1713789817,
        },
        'message': 'Login successful with auth code',
        'status': 'LOGIN SUCCESSFUL',
      };

      return Response(
          requestOptions: RequestOptions(),
          data: successJson,
          statusCode: 200,);
    } else {
      /*final failedJson = {
        'data': {
          'email_address': 'test@gigantic.com',
        },
        'status': 'LOGIN UNSUCCESSFUL',
        'message': 'Email/auth code did not match, try again',
      };*/
      return null;
    }
  }

}
