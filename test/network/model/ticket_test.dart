import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart';

void main() {

  test('map json to tickets', () {

    const expectedTicketId = '7047174321798659bec782be84860353002';
    const expectedBarcode = '1517102976';
    const expectedHeading = 'General Admission Standing';
    const expectedLabel = 'label';
    const expectedFaceValue = 57.50;
    const expectedBookingFee = 6.90;
    const expectedCancelledDate = 100;
    const expectedEntranceInfo = 'entrance info';
    const expectedEntranceArea = 'entrance area';
    const expectedEntranceAisle = 'entrance aisle';
    const expectedEntranceGate = 'entrance gate';
    const expectedEntranceCodes = 'entrance codes';
    const expectedEntrancePassageway = 'entrance passageway';
    const expectedEntranceTurnstiles = 'entrance turnstiles';
    const expectedEntranceStand = 'entrance stand';
    const expectedTransferTo = 'transfer to';
    const expectedTransferDate = 200;
    const expectedStartTimeOverride = 300;
    const expectedEventTimeOverride = 400;
    const expectedEndTimeOverride = 500;

    const json = {
    'barcode': expectedBarcode,
    'number': 'GIG7186902881',
    'heading': expectedHeading,
    'label': expectedLabel,
    'face_value': '$expectedFaceValue',
    'booking_fee': '$expectedBookingFee',
    'ticket_cancelled_timestamp': '$expectedCancelledDate',
    'entrance_info': expectedEntranceInfo,
    'entrance_area': expectedEntranceArea,
    'entrance_aisle': expectedEntranceAisle,
    'entrance_gate': expectedEntranceGate,
    'entrance_codes': expectedEntranceCodes,
    'entrance_passageway': expectedEntrancePassageway,
    'entrance_turnstiles': expectedEntranceTurnstiles,
    'entrance_stand': expectedEntranceStand,
    'transfer_to': expectedTransferTo,
    'transfer_timestamp': expectedTransferDate,
    'ticket_count': 1,
    'start_time_override': '$expectedStartTimeOverride',
    'event_time_override': '$expectedEventTimeOverride',
    'end_time_override': '$expectedEndTimeOverride',
    };

    final ticket = Ticket.fromJson(expectedTicketId, json);

    expect(ticket.id, expectedTicketId, reason: 'unexpected ticket id');
    expect(ticket.barcode, expectedBarcode,
        reason: 'unexpected ticket barcode',);
    expect(ticket.heading, expectedHeading,
        reason: 'unexpected ticket heading',);
    expect(ticket.label, expectedLabel, reason: 'unexpected ticket label');
    expect(ticket.value, expectedFaceValue,
        reason: 'unexpected ticket face value',);
    expect(ticket.bookingFee, expectedBookingFee,
        reason: 'unexpected ticket booking fee',);
    //the json dates are in seconds so converted to
    // milliseconds by multiplying by 1000
    expect(ticket.ticketCancelledDate?.millisecondsSinceEpoch,
        expectedCancelledDate * 1000,
        reason: 'unexpected ticket cancellation date',);
    expect(ticket.entranceInfo, expectedEntranceInfo,
        reason: 'unexpected ticket entrance info',);
    expect(ticket.entranceArea, expectedEntranceArea,
        reason: 'unexpected ticket entrance area',);
    expect(ticket.entranceAisle, expectedEntranceAisle,
        reason: 'unexpected ticket entrance aisle',);
    expect(ticket.entranceGate, expectedEntranceGate,
        reason: 'unexpected ticket entrance gate',);
    expect(ticket.entranceCodes, expectedEntranceCodes,
        reason: 'unexpected ticket entrance codes',);
    expect(ticket.entrancePassageway, expectedEntrancePassageway,
        reason: 'unexpected ticket entrance passageway',);
    expect(ticket.entranceTurnstiles, expectedEntranceTurnstiles,
        reason: 'unexpected ticket entrance turnstiles',);
    expect(ticket.entranceStand, expectedEntranceStand,
        reason: 'unexpected ticket entrance stand',);
    expect(ticket.transferTo, expectedTransferTo,
        reason: 'unexpected ticket transfer to',);
    expect(ticket.transferTimestamp?.millisecondsSinceEpoch,
        expectedTransferDate * 1000,
        reason: 'unexpected ticket transfer date',);
    expect(ticket.startTimeOverride?.millisecondsSinceEpoch,
        expectedStartTimeOverride * 1000,
        reason: 'unexpected ticket start time override',);
    expect(ticket.eventTimeOverride?.millisecondsSinceEpoch,
        expectedEventTimeOverride * 1000,
        reason: 'unexpected ticket event time override',);
    expect(ticket.endTimeOverride?.millisecondsSinceEpoch,
        expectedEndTimeOverride * 1000,
        reason: 'unexpected ticket end time override',);

  });

}
