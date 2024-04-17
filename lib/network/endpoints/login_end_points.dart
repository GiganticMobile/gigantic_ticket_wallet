import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/api_constants.dart';
import 'package:gigantic_ticket_wallet/network/common/checks.dart';

/// this contains all the endpoints related to logging in
class LoginEndPoints extends LoginEndPointsInterface {

  @override
  Future<Response<dynamic>?> login(String email, String password) async {
    late final Response<dynamic> response;
    try {
      final dio = APIConstants.getInstance();
      response = await dio.post(
          'login.php',
          queryParameters: {'email': email, 'password': password},
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
