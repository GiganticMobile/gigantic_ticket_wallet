import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/api_constants.dart';
import 'package:gigantic_ticket_wallet/network/common/Checks.dart';

/// this contains all the endpoints related to verification
class VerificationEndPoints extends VerificationEndPointsInterface {
  @override
  Future<Response<dynamic>?> verify(String email, String code) async {
    final dio = APIConstants.getInstance();
    late final Response<dynamic> response;
    try {
      response = await dio.post(
        'login.php',
        queryParameters: {'email': email, 'auth_code': code},
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
abstract class VerificationEndPointsInterface {
  /// return verify endpoint of the api
  Future<Response<dynamic>?> verify(String email, String code);
}
