import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';

/// handles interactions on the order database
class OrderDatabase extends OrderDatabaseInterface {
  @override
  Future<void> addOrder(OrderData order) async {
    final database = GetIt.I.get<AppDatabase>();

    final inserting = OrderCompanion.insert(
        id: order.id,
        reference: order.reference,
        event: order.event,
        venue: order.venue,
        startTime: order.startTime,);

    await database.into(database.order).insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<OrderData>> getOrders() async {
    final database = GetIt.I.get<AppDatabase>();

    final orders = await database.select(database.order).get();

    return orders;
  }

}

///
abstract class OrderDatabaseInterface {

  ///
  Future<void> addOrder(OrderData order);

  ///
  Future<List<OrderData>> getOrders();
}
