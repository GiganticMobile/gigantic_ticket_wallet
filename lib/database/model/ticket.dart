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

  @override
  Set<Column> get primaryKey => {id};
}
