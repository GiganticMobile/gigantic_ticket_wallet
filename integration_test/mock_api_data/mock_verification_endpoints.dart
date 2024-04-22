import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';

class MockVerificationEndPoints extends VerificationEndPointsInterface {
  @override
  Future<Response<dynamic>?> verify(String email, String code) async {
    if (email == 'test@gigantic.com' && code == '999111') {
      return Response(
          requestOptions: RequestOptions(),
          data: _verificationSuccess,);
    } else {
      return Response(
        requestOptions: RequestOptions(),
        data: _verificationFailed,
        statusCode: 401,);
    }
  }

  final _verificationFailed = {
    'data': {
      'email_address': 'test@gigantic.com',
    },
    'status': 'LOGIN UNSUCCESSFUL',
    'message': '',
  };

  final _verificationSuccess = {
    'data': {
      'email_address': 'test@gigantic.com',
      'login_timestamp': 1713533906,
    },
    'message': 'Login successful with auth code',
    'status': 'LOGIN SUCCESSFUL',
  };

}
