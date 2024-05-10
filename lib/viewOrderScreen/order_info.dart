
/// contains the order information being displayed on the ui
class OrderInfo {
  /// constructor
  OrderInfo({
    required this.orderReference,
    required this.event,
    required this.tickets,
  });

  ///
  final String orderReference;

  ///
  final EventInfo event;

  ///
  final List<TicketInfo> tickets;

}

/// contains the event information being displayed on the ui
class EventInfo {
  /// constructor
  EventInfo({
    required this.title,
    required this.startDate,
    required this.doorsOpenTime,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.image,
    required this.venue,
  });

  ///
  final String title;
  /// this is the event date in day / month / year format
  final String startDate;
  /// this only the time not date
  final String doorsOpenTime;
  /// this only the time not date
  final String startTime;
  /// this only the time not date
  final String endTime;
  ///
  final String description;
  ///this is a promotional image of the event
  final String image;
  ///
  final VenueInfo venue;
}

/// contains the venue information being displayed on the ui
class VenueInfo {
  ///constructor
  VenueInfo({
    required this.address,
    required this.description,
  });

  ///
  final String address;
  ///
  final String description;
}

/// contains the ticket information being displayed on the ui
class TicketInfo {
  /// constructor
  TicketInfo({
    required this.barcode,
    required this.showAt,
    required this.heading,
    required this.label,
    required this.value,
    required this.seatBlock,
    required this.seatRow,
    required this.seatNum,
    this.entrance,
    this.entranceGate,
    this.entranceStand,
    this.entranceArea,
    this.entranceAisle,
    this.entranceCodes,
    this.entrancePassageway,
    this.entranceTurnstiles,
  });

  ///
  final String barcode;
  /// show barcode after this time
  final DateTime showAt;
  /// ticket title
  final String heading;
  ///
  final String label;
  ///this is the price of the ticket
  final String value;
  ///
  final String seatBlock;
  ///
  final String seatRow;
  ///
  final String seatNum;
  /// this can be null as not all tickets will have this information
  final String? entrance;
  /// this can be null as not all tickets will have this information
  final String? entranceGate;
  /// this can be null as not all tickets will have this information
  final String? entranceStand;
  /// this can be null as not all tickets will have this information
  final String? entranceArea;
  /// this can be null as not all tickets will have this information
  final String? entranceAisle;
  /// this can be null as not all tickets will have this information
  final String? entranceCodes;
  /// this can be null as not all tickets will have this information
  final String? entrancePassageway;
  /// this can be null as not all tickets will have this information
  final String? entranceTurnstiles;
}
