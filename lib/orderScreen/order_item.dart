/// this represents the order information displayed on the ui
class OrderItem {
  /// constructor
  OrderItem({
    required this.imageUrl,
    required this.eventName,
    required this.eventStartDate,
    required this.venueLocation,
    required this.orderReference,
    required this.ticketAmount,
    required this.transferredTicketAmount,
  });

  /// promotional image of the event
  final String imageUrl;
  ///
  final String eventName;
  /// event date in the format of Saturday 16th March 2024
  final String eventStartDate;
  /// full address of the venue
  final String venueLocation;
  ///
  final String orderReference;
  /// the number of tickets the user has excluding transferred tickets
  final int ticketAmount;
  /// the number of transferred tickets
  final int transferredTicketAmount;
}
