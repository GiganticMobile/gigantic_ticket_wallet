import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';

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

}
