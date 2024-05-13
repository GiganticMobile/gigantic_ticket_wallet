import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/utils/date_utils.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/order_info.dart';

/// this handles the business logic for the view order screen
class ViewOrderScreenRepository extends ViewOrderScreenRepositoryInterface {
  /// constructor
  ViewOrderScreenRepository(
      OrderDatabaseInterface orderDatabase,
      EventDatabaseInterface eventDatabase,
      TicketDatabaseInterface ticketDatabase,
      ) :
        _orderDatabase = orderDatabase,
        _eventDatabase = eventDatabase,
        _ticketDatabase = ticketDatabase;

  final OrderDatabaseInterface _orderDatabase;
  final EventDatabaseInterface _eventDatabase;
  final TicketDatabaseInterface _ticketDatabase;

  @override
  Future<OrderInfo?> getOrder(String orderId) async {
    final order = await _orderDatabase.getOrder(orderId);
    final event = await _eventDatabase.getEventByOrder(orderId);
    final tickets = await _ticketDatabase.getTicketsForOrder(orderId);

    if (order == null) {
      return null;
    }

    final String venueAddress;
    if (event != null) {
      venueAddress =
      '${event.venueAddress}, ${event.venueCity}, ${event.venuePostcode}';
    } else {
      venueAddress = '';
    }

    final String eventStartDate;
    if (event != null) {
      final eventDateTime =
      DateTime.fromMillisecondsSinceEpoch(event.doorsOpenTime);

      eventStartDate =
          CommonDateUtils.convertDateTimeToLongDateString(eventDateTime);
    } else {
      eventStartDate = '';
    }

    final String doorsOpenTime;
    if (event != null) {
      final doorOpenDateTime =
      DateTime.fromMillisecondsSinceEpoch(event.doorsOpenTime);

      doorsOpenTime = CommonDateUtils.convertTimeToString(doorOpenDateTime);
    } else {
      doorsOpenTime = '';
    }

    final String startTime;
    if (event != null) {
      final startDateTime =
      DateTime.fromMillisecondsSinceEpoch(event.startTime);

      startTime = CommonDateUtils.convertTimeToString(startDateTime);
    } else {
      startTime = '';
    }

    final String endTime;
    if (event != null) {
      final endDateTime =
      DateTime.fromMillisecondsSinceEpoch(event.endTime);

      endTime = CommonDateUtils.convertTimeToString(endDateTime);
    } else {
      endTime = '';
    }

    return OrderInfo(
      orderReference: order.reference,
      event: EventInfo(
        title: event?.title ?? '',
        startDate: eventStartDate,
        doorsOpenTime: doorsOpenTime,
        startTime: startTime,
        endTime: endTime,
        description: '',
        image: event?.campaignImage ?? '',
        venue: VenueInfo(
            address: venueAddress,
            description: '',
            longitude: event?.venueLongitude,
            latitude: event?.venueLatitude,),
      ), tickets: tickets.map((ticket) {

        final DateTime showAt;
        if (event?.doorsOpenTime != null) {
          showAt =
              DateTime.fromMillisecondsSinceEpoch(event?.doorsOpenTime ?? 0);
        } else {
          showAt = DateTime.now();
        }

      return TicketInfo(
        barcode: ticket.barcode,
        showAt: showAt,
        heading: ticket.heading,
        label: ticket.label,
        value: ticket.value.toStringAsFixed(2),
        seatBlock: 'block',
        seatRow: 'A',
        seatNum: '12',
        entrance: ticket.entranceInfo,
        entranceGate: ticket.entranceGate,
        entranceStand: ticket.entranceStand,
        entranceArea: ticket.entranceArea,
        entranceAisle: ticket.entranceAisle,
        entranceCodes: ticket.entranceCodes,
        entrancePassageway: ticket.entrancePassageway,
        entranceTurnstiles: ticket.entranceTurnstiles,
      );
    }).toList(),
    );
  }

}

///
abstract class ViewOrderScreenRepositoryInterface {

  ///
  Future<OrderInfo?> getOrder(String orderId);

}
