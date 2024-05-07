import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';

///handles interactions with the tickets in the database
class TicketDatabase extends TicketDatabaseInterface {
  /// constructor
  TicketDatabase({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<void> addTicket(TicketData ticket) async {
    final inserting = TicketCompanion.insert(
      id: ticket.id,
      order: ticket.order,
      barcode: ticket.barcode,
      heading: ticket.heading,
      label: ticket.label,
      value: ticket.value,
      bookingFee: ticket.bookingFee,
      ticketCancelledDate: Value(ticket.ticketCancelledDate),
      entranceInfo: ticket.entranceInfo,
      entranceArea: ticket.entranceArea,
      entranceAisle: ticket.entranceAisle,
      entranceGate: ticket.entranceGate,
      entranceCodes: ticket.entranceCodes,
      entrancePassageway: ticket.entrancePassageway,
      entranceTurnstiles: ticket.entranceTurnstiles,
      entranceStand: ticket.entranceStand,
      transferTo: ticket.transferTo,
      transferTimestamp: Value(ticket.transferTimestamp),
      doorsOpenTimeOverride: Value(ticket.doorsOpenTimeOverride),
      eventTimeOverride: Value(ticket.eventTimeOverride),
      endTimeOverride: Value(ticket.endTimeOverride),
    );

    await _database.into(_database.ticket).insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<TicketData>> getTickets() async {
    final tickets = await _database.select(_database.ticket).get();

    return tickets;
  }

}

///
abstract class TicketDatabaseInterface {

  ///
  Future<void> addTicket(TicketData ticket);

  ///
  Future<List<TicketData>> getTickets();
}
