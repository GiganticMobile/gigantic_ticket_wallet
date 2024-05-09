import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

/// ticket returned by api
class Ticket {
  /// constructor
  Ticket({
    required this.id,
    required this.barcode,
    required this.heading,
    required this.label,
    required this.value,
    required this.bookingFee,
    required this.ticketCancelledDate,
    required this.entranceInfo,
    required this.entranceArea,
    required this.entranceAisle,
    required this.entranceGate,
    required this.entranceCodes,
    required this.entrancePassageway,
    required this.entranceTurnstiles,
    required this.entranceStand,
    required this.transferTo,
    required this.transferTimestamp,
    required this.doorsTimeOverride,
    required this.eventTimeOverride,
    required this.endTimeOverride,
  });

  ///convert json to ticket
  Ticket.fromJson(String ticketId, dynamic json) {
    try {
      if (json case {
      'barcode': final String barcode,
      'heading': final String heading,
      'label': final String label,
      'face_value': final String value,
      'booking_fee': final String bookingFee,
      'ticket_cancelled_timestamp': final String ticketCancelledDate,
      'entrance_info': final String entranceInfo,
      'entrance_area': final String entranceArea,
      'entrance_aisle': final String entranceAisle,
      'entrance_gate': final String entranceGate,
      'entrance_codes': final String entranceCodes,
      'entrance_passageway': final String entrancePassageway,
      'entrance_turnstiles': final String entranceTurnstiles,
      'entrance_stand': final String entranceStand,
      'transfer_to': final String transferTo,
      'transfer_timestamp': final int transferTimestamp,
      'start_time_override': final String startTimeOverride,
      'event_time_override': final String eventTimeOverride,
      'end_time_override': final String endTimeOverride,
      }) {
        //final startTime = DateTime.now().add(const Duration(minutes: 2))

        id = ticketId;
        this.barcode = barcode;
        this.heading = heading;
        this.label = label;
        this.value = double.tryParse(value) ?? 0;
        this.bookingFee = double.tryParse(bookingFee) ?? 0;

        final cancellationDate = int.tryParse(ticketCancelledDate) ?? 0;
        if (cancellationDate != 0) {
          this.ticketCancelledDate =
              CommonDateUtils.getDateFromInt(cancellationDate);
        } else {
          this.ticketCancelledDate = null;
        }

        if (entranceInfo.isEmpty) {
          this.entranceInfo = null;
        } else {
          this.entranceInfo = entranceInfo;
        }

        if (entranceArea.isEmpty) {
          this.entranceArea = null;
        } else {
          this.entranceArea = entranceArea;
        }

        if (entranceAisle.isEmpty) {
          this.entranceAisle = null;
        } else {
          this.entranceAisle = entranceAisle;
        }

        if (entranceGate.isEmpty) {
          this.entranceGate = null;
        } else {
          this.entranceGate = entranceGate;
        }

        if (entranceCodes.isEmpty) {
          this.entranceCodes = null;
        } else {
          this.entranceCodes = entranceCodes;
        }

        if (entrancePassageway.isEmpty) {
          this.entrancePassageway = null;
        } else {
          this.entrancePassageway = entrancePassageway;
        }

        if (entranceTurnstiles.isEmpty) {
          this.entranceTurnstiles = null;
        } else {
          this.entranceTurnstiles = entranceTurnstiles;
        }

        if (entranceStand.isEmpty) {
          this.entranceStand = null;
        } else {
          this.entranceStand = entranceStand;
        }

        if (transferTo.isEmpty) {
          this.transferTo = null;
        } else {
          this.transferTo = transferTo;
        }

        final transferredDate = int.tryParse(transferTimestamp.toString()) ?? 0;
        if (transferredDate != 0) {
          this.transferTimestamp =
              CommonDateUtils.getDateFromInt(transferredDate);
        } else {
          this.transferTimestamp = null;
        }

        final startTimeOverrideDate = int.tryParse(startTimeOverride) ?? 0;
        if (startTimeOverrideDate != 0) {
          doorsTimeOverride =
              CommonDateUtils.getDateFromInt(startTimeOverrideDate);
        } else {
          doorsTimeOverride = null;
        }

        final eventTimeOverrideDate = int.tryParse(eventTimeOverride) ?? 0;
        if (transferredDate != 0) {
          this.eventTimeOverride =
              CommonDateUtils.getDateFromInt(eventTimeOverrideDate);
        } else {
          this.eventTimeOverride = null;
        }

        final endTimeOverrideDate = int.tryParse(endTimeOverride) ?? 0;
        if (endTimeOverrideDate != 0) {
          this.endTimeOverride =
              CommonDateUtils.getDateFromInt(endTimeOverrideDate);
        } else {
          this.endTimeOverride = null;
        }

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
  ///
  late final double bookingFee;
  ///this is null if the ticket is not cancelled
  late final DateTime? ticketCancelledDate;
  /// not all tickets will have this info
  late final String? entranceInfo;
  /// not all tickets will have this info
  late final String? entranceArea;
  /// not all tickets will have this info
  late final String? entranceAisle;
  /// not all tickets will have this info
  late final String? entranceGate;
  /// not all tickets will have this info
  late final String? entranceCodes;
  /// not all tickets will have this info
  late final String? entrancePassageway;
  /// not all tickets will have this info
  late final String? entranceTurnstiles;
  /// not all tickets will have this info
  late final String? entranceStand;
  /// if null ticket not transferred
  late final String? transferTo;
  /// if null ticket not transferred
  late final DateTime? transferTimestamp;
  /// if null no start time override
  late final DateTime? doorsTimeOverride;
  /// if null no event time override
  late final DateTime? eventTimeOverride;
  /// if null no end time override
  late final DateTime? endTimeOverride;
}
