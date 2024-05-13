import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart' as api;

/// order model for database
class Order extends Table {

  ///
  TextColumn get id => text()();
  ///
  TextColumn get reference => text()();
  /// event start time in millisecondsSinceEpoch
  IntColumn get startTime => integer()();
  ///
  BoolColumn get hasRefundPlan => boolean()();
  ///
  IntColumn get event => integer().nullable().references(Event, #id)();

  @override
  Set<Column> get primaryKey => {id};

  ///this is used to convert the order information provided by the
  ///api into an order that can be stored in the database
  static OrderData fromNetwork(api.Order order) {
    return OrderData(
      id: order.id,
      reference: order.orderReference,
      startTime: order.event.doorsOpenTime.millisecondsSinceEpoch,
      hasRefundPlan: order.hasRefundPlan,
    );
  }

}
