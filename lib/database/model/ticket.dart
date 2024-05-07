import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';

/// ticket model for database
class Ticket extends Table {
  ///
  TextColumn get id => text()();
  /// the id of the order the ticket is related to
  TextColumn get order =>
      text().references(Order, #id, onDelete: KeyAction.cascade)();
  ///
  TextColumn get barcode => text()();
  ///
  TextColumn get heading => text()();
  ///
  TextColumn get label => text()();
  /// ticket price
  RealColumn get value => real()();
  ///
  RealColumn get bookingFee => real()();
  ///null cancelled date means ticket has not been cancelled
  ///time in millisecondsSinceEpoch
  IntColumn get ticketCancelledDate => integer().nullable()();
  ///
  TextColumn get entranceInfo => text()();
  ///
  TextColumn get entranceArea => text()();
  ///
  TextColumn get entranceAisle => text()();
  ///
  TextColumn get entranceGate => text()();
  ///
  TextColumn get entranceCodes => text()();
  ///
  TextColumn get entrancePassageway => text()();
  ///
  TextColumn get entranceTurnstiles => text()();
  ///
  TextColumn get entranceStand => text()();
  ///
  TextColumn get transferTo => text()();
  ///null cancelled date means ticket has not been transferred
  ///time in millisecondsSinceEpoch
  IntColumn get transferTimestamp => integer().nullable()();
  ///null cancelled date means ticket doors open time has not been overridden
  ///time in millisecondsSinceEpoch
  IntColumn get doorsOpenTimeOverride => integer().nullable()();
  ///null cancelled date means ticket event time has not been overridden
  ///time in millisecondsSinceEpoch
  IntColumn get eventTimeOverride => integer().nullable()();
  ///null cancelled date means ticket end time has not been overridden
  ///time in millisecondsSinceEpoch
  IntColumn get endTimeOverride => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
