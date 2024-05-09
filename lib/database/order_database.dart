import 'package:gigantic_ticket_wallet/database/database.dart';

/// handles interactions on the order database
class OrderDatabase extends OrderDatabaseInterface {
  /// constructor
  OrderDatabase({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<void> addOrder(OrderData order) async {
    final inserting = OrderCompanion.insert(
        id: order.id,
        reference: order.reference,
        startTime: order.startTime,
        hasRefundPlan: order.hasRefundPlan,);

    await _database.into(_database.order).insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<OrderData>> getOrders() async {
    final orders = await _database.select(_database.order).get();

    return orders;
  }

  @override
  Future<OrderData?> getOrder(String id) async {
    final order = await (_database.select(_database.order)
        ..where((order) => order.id.equals(id)))
      .getSingleOrNull();

    return order;
  }

}

///
abstract class OrderDatabaseInterface {

  ///
  Future<void> addOrder(OrderData order);

  ///
  Future<List<OrderData>> getOrders();

  ///
  Future<OrderData?> getOrder(String id);
}
