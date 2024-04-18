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

  ///
  final String id;
  ///
  final String barcode;
  ///
  final String heading;
  ///
  final String label;
  /// ticket price
  final double value;
}
