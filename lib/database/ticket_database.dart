import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';

///handles interactions with the tickets in the database
class TicketDatabase extends TicketDatabaseInterface {
  @override
  Future<void> addTicket(TicketData ticket) async {
    final database = GetIt.I.get<AppDatabase>();

    final inserting = TicketCompanion.insert(
      id: ticket.id,
      order: ticket.order,
      barcode: ticket.barcode,
      heading: ticket.heading,
      label: ticket.label,
      value: ticket.value,);

    await database.into(database.ticket).insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<TicketData>> getTickets() async {
    final database = GetIt.I.get<AppDatabase>();

    final tickets = await database.select(database.ticket).get();

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
