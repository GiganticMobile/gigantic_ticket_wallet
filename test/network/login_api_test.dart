import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';
import 'package:gigantic_ticket_wallet/network/login_api.dart';

void main() {
  
  test('successful login api response test', () async {

    final endpoint = MockLoginEndPoint(isSuccessful: true);
    final api = LoginAPI(endPoints: endpoint);

    //it does not matter what the user name and password
    //are at the api will return the same result.
    final result = await api.login('test', 'test');

    //if the api fails of is unsuccessful then it should return a
    //null value. Which is should not in this test.
    expect(result, isNotNull, reason: 'unexpected login api result');

  });

  test('failed login api response test', () async {
    final endpoint = MockLoginEndPoint(isSuccessful: false);
    final api = LoginAPI(endPoints: endpoint);

    //it does not matter what the user name and password
    //are at the api will return the same result.
    final result = await api.login('test', 'test');

    //if the api fails of is unsuccessful then it should return a
    //null value.
    expect(result, isNull, reason: 'unexpected login api result');
  });
  
}

class MockLoginEndPoint extends LoginEndPointsInterface {
  MockLoginEndPoint({required bool isSuccessful}) 
      : _isSuccessful = isSuccessful;
  final bool _isSuccessful;
  
  @override
  Future<Response<dynamic>?> login(String email, String password) async {
    if (_isSuccessful) {
      final successJson = {
        'data': {
          'email_address': 'test@gigantic.com',
          'login_timestamp': 1713787728,
        },
        'message': 'Login successful with password',
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
        'message': '',
      };*/

      return null;
    }
  }
  
}
