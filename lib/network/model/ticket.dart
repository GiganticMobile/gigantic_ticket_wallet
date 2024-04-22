/// ticket returned by api
class Ticket {
  /// constructor
  Ticket({
    required this.id,
    required this.barcode,
    required this.heading,
    required this.label,
    required this.value,
  });

  ///convert json to ticket
  Ticket.fromJson(String ticketId, dynamic json) {
    try {
      if (json case {
      'barcode': final String barcode,
      'heading': final String heading,
      'label': final String label,
      'face_value': final String value,
      }) {
        //final startTime = DateTime.now().add(const Duration(minutes: 2))

        id = ticketId;
        this.barcode = barcode;
        this.heading = heading;
        this.label = label;
        this.value = double.tryParse(value) ?? 0;
      } else {
        throw Exception('unable to map to json');
      }
    } catch (_) {
      throw Exception('unable to map to json');
    }
  }

  ///
  late final String id;
  ///
  late final String barcode;
  ///
  late final String heading;
  ///
  late final String label;
  /// ticket price
  late final double value;
}
