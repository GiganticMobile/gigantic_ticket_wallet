import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/api_constants.dart';

/// end points for orders and tickets
class OrderEndPoints extends OrderEndPointsInterface {

  @override
  Future<Response<dynamic>?> getAllOrders() async {
    late final Response<dynamic> response;
    try {
      final dio = APIConstants.getInstance();
      response = await dio.post(
        'fetch_orders_by_email.php',
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
    return response;
  }
}

///
abstract class OrderEndPointsInterface {

  /// get orders and the tickets from the api
  Future<Response<dynamic>?> getAllOrders();
}
