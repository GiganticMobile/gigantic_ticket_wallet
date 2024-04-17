import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/common/auth.dart';
import 'package:gigantic_ticket_wallet/network/common/checks.dart';

/// this contains all the endpoints related to logging in
class LoginEndPoints extends LoginEndPointsInterface {

  final _dio = Dio();
  final _baseUrl = 'https://www.gigantic.com/';

  @override
  Future<Response<dynamic>?> login(String email, String password) async {
    late final Response<dynamic> response;
    try {
      response = await _dio.post(
          '${_baseUrl}wallet_app/login.php',
          queryParameters: {'email': email, 'password': password},
          options: Options(headers: {
            'Authorization': Auth.getAuthToken(),
          },
              preserveHeaderCase: true,
          ),
      );
    } on DioException catch (e) {

      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          // unauthorised access
          return null;
        }
      } else {
        //unexpected error
        return null;
      }

    } catch (e) {
      //unexpected error
      return null;
    }

    try {
      if (response.statusCode != null) {
        Checks.checkResponseCode(response.statusCode!);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }

    return response;
  }

}

///
abstract class LoginEndPointsInterface {

  /// return login endpoint of the api
  Future<Response<dynamic>?> login(String email, String password);

}
