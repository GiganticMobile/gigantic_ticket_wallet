import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';

class MockLoginEndPoints extends LoginEndPointsInterface {
  @override
  Future<Response<dynamic>?> login(String email, String password) async {
    if (email == 'test@gigantic.com' && password == '123654') {
      return Response(requestOptions: RequestOptions(), data: _loginSuccessful);
    } else {
      return Response(
          requestOptions: RequestOptions(),
          data: _loginFailed,
          statusCode: 401,);
    }
  }

  final _loginFailed = {
    'data': {
      'email_address': 'test@gigantic.com',
    },
    'status': 'LOGIN UNSUCCESSFUL',
    'message': '',
  };

  final _loginSuccessful = {
    'data': {
      'email_address': 'test@gigantic.com',
      'login_timestamp': 1713532932,
    },
    'message': 'Login successful with password',
    'status': 'LOGIN SUCCESSFUL',
  };
}
