import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart';

/// handles interactions for the order api
class OrderAPI extends OrderAPIInterface {
  /// constructor
  OrderAPI({required OrderEndPointsInterface endPoints})
      : _endpoints = endPoints;

  final OrderEndPointsInterface _endpoints;

  @override
  Future<List<Order>> getOrders() async {
    final response = await _endpoints.getAllOrders();

    if (response == null) {
      return List.empty();
    }

    /*
    if (response.data['status'] == 'LOGIN SUCCESSFUL') {
      final result = LoginResult.fromJson(response.data);
      return result;
    } else {
      return null;
    }
     */
    
    return _mapJsonToOrders(response.data);
  }

  Future<List<Order>> _mapJsonToOrders(dynamic json) async {
    final orders = List<Order>.empty(growable: true);
    if (json case {
    'orders': final Map<String, dynamic> orderJson,
    }) {
      for (final orderId in orderJson.keys) {
        final order = Order.fromJson(orderId, orderJson[orderId]);

        orders.add(order);
      }
    }

    return orders;
  }
}

///
abstract class OrderAPIInterface {

  /// get orders from api
  Future<List<Order>> getOrders();

}
