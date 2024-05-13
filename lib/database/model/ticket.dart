import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart' as api;

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
  /// not all tickets will have this info
  TextColumn get entranceInfo => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceArea => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceAisle => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceGate => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceCodes => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entrancePassageway => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceTurnstiles => text().nullable()();
  /// not all tickets will have this info
  TextColumn get entranceStand => text().nullable()();
  /// if null then ticket is not transferred
  TextColumn get transferTo => text().nullable()();
  ///null transfer date means ticket has not been transferred
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

  ///this is used to convert the ticket information provided by the
  ///api into a ticket that can be stored in the database
  static TicketData fromNetwork(String orderId, api.Ticket ticket) {
    return TicketData(
      id: ticket.id,
      order: orderId,
      barcode: ticket.barcode,
      heading: ticket.heading,
      label: ticket.label,
      value: ticket.value,
      bookingFee: ticket.bookingFee,
      ticketCancelledDate:
      ticket.ticketCancelledDate?.millisecondsSinceEpoch,
      entranceInfo: ticket.entranceInfo,
      entranceArea: ticket.entranceArea,
      entranceAisle: ticket.entranceAisle,
      entranceGate: ticket.entranceGate,
      entranceCodes: ticket.entranceCodes,
      entrancePassageway: ticket.entrancePassageway,
      entranceTurnstiles: ticket.entranceTurnstiles,
      entranceStand: ticket.entranceStand,
      transferTo: ticket.transferTo,
      transferTimestamp:
      ticket.transferTimestamp?.millisecondsSinceEpoch,
      doorsOpenTimeOverride:
      ticket.doorsTimeOverride?.millisecondsSinceEpoch,
      eventTimeOverride:
      ticket.eventTimeOverride?.millisecondsSinceEpoch,
      endTimeOverride: ticket.endTimeOverride?.millisecondsSinceEpoch,
    );
  }
}
