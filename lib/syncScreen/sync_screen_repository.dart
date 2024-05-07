import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';

/// this handles business logic of the sync screen
class SyncScreenRepository extends SyncScreenRepositoryInterface {
  /// constructor
  SyncScreenRepository({
    required OrderAPIInterface api,
    required OrderDatabaseInterface orderDatabase,
    required EventDatabaseInterface eventDatabase,
    required TicketDatabaseInterface ticketDatabase,})
      : _api = api,
        _orderDatabase = orderDatabase,
        _eventDatabase = eventDatabase,
        _ticketDatabase = ticketDatabase;

  final OrderAPIInterface _api;
  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;
  final TicketDatabaseInterface _ticketDatabase;

  @override
  Future<void> syncOrders() async {

    final apiOrders = await _api.getOrders();

    for (final order in apiOrders) {
      await _orderDatabase.addOrder(
          OrderData(
              id: order.id,
              reference: order.orderReference,
              startTime: order.event.doorsOpenTime.millisecondsSinceEpoch,
              hasRefundPlan: order.hasRefundPlan,
          ),
      );

      await _eventDatabase.addEvent(
        EventData(
            id: 0,
            order: order.id,
            presenter: order.event.presenter,
            title: order.event.title,
            subTitle: order.event.subTitle,
            doorsOpenTime: order.event.doorsOpenTime.millisecondsSinceEpoch,
            startTime: order.event.startTime.millisecondsSinceEpoch,
            endTime: order.event.endTime.millisecondsSinceEpoch,
            seatingPlan: order.event.seatingPlan,
            venue: order.event.venue,
            venueAddress: order.event.venueAddress,
            venueCity: order.event.venueCity,
            venuePostcode: order.event.venuePostcode,
            venueType: order.event.venueType,
            campaignImage: order.event.campaignImage,
            eventImage: order.event.eventImage,
            restriction: order.event.restriction,
            promoter: order.event.promoter,),
      );

      for (final ticket in order.tickets) {
        await _ticketDatabase.addTicket(
            TicketData(
                id: ticket.id,
                order: order.id,
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
            ),
        );
      }
    }
  }

}

///
abstract class SyncScreenRepositoryInterface {

  /// this gets the latest version of the orders an tickets
  /// and saves them to the database
  Future<void> syncOrders();
}
