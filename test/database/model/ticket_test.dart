import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/model/ticket.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart' as api;

void main() {

  test('check ticket from api maps to ticket database', () {

    const expectedOrderId = '1';
    const expectedTicketId = '2';
    const expectedBarcode = '123456';
    const expectedHeading = 'heading';
    const expectedLabel = 'label';
    const expectedValue = 10.0;
    const expectedBookingFee = 2.0;
    const expectedTicketCancelledDate = 1000;
    const expectedEntranceInfo = 'entrance info';
    const expectedEntranceArea = 'entrance area';
    const expectedEntranceAisle = 'entrance aisle';
    const expectedEntranceGate = 'entrance gate';
    const expectedEntranceCodes = 'entrance codes';
    const expectedEntrancePassageway = 'entrance passageway';
    const expectedEntranceTurnstiles = 'entrance turnstiles';
    const expectedEntranceStand = 'entrance stand';
    const expectedTransferTo = 'transfer to';
    const expectedTransferTimeStamp = 2000;
    const expectedDoorsOpenTime = 3000;
    const expectedEventTime = 4000;
    const expectedEndTime = 5000;

    final ticket = api.Ticket(
      id: expectedTicketId,
      barcode: expectedBarcode,
      heading: expectedHeading,
      label: expectedLabel,
      value: expectedValue,
      bookingFee: expectedBookingFee,
      ticketCancelledDate:
      DateTime.fromMillisecondsSinceEpoch(expectedTicketCancelledDate),
      entranceInfo: expectedEntranceInfo,
      entranceArea: expectedEntranceArea,
      entranceAisle: expectedEntranceAisle,
      entranceGate: expectedEntranceGate,
      entranceCodes: expectedEntranceCodes,
      entrancePassageway: expectedEntrancePassageway,
      entranceTurnstiles: expectedEntranceTurnstiles,
      entranceStand: expectedEntranceStand,
      transferTo: expectedTransferTo,
      transferTimestamp:
      DateTime.fromMillisecondsSinceEpoch(expectedTransferTimeStamp),
      doorsTimeOverride:
      DateTime.fromMillisecondsSinceEpoch(expectedDoorsOpenTime),
      eventTimeOverride: DateTime.fromMillisecondsSinceEpoch(expectedEventTime),
      endTimeOverride: DateTime.fromMillisecondsSinceEpoch(expectedEndTime),
    );

    final result = Ticket.fromNetwork(expectedOrderId, ticket);

    expect(result.order, expectedOrderId, reason: 'unexpected ticket order id');
    expect(result.id, expectedTicketId, reason: 'unexpected ticket id');
    expect(result.barcode, expectedBarcode,
        reason: 'unexpected ticket barcode',);
    expect(result.heading, expectedHeading,
        reason: 'unexpected ticket heading',);
    expect(result.label, expectedLabel, reason: 'unexpected ticket label');
    expect(result.value, expectedValue, reason: 'unexpected ticket value');
    expect(result.bookingFee, expectedBookingFee,
        reason: 'unexpected ticket booking fee',);
    expect(result.ticketCancelledDate, expectedTicketCancelledDate,
        reason: 'unexpected ticket cancelled date',);
    expect(result.entranceInfo, expectedEntranceInfo,
        reason: 'unexpected ticket entrance info',);
    expect(result.entranceArea, expectedEntranceArea,
        reason: 'unexpected ticket entrance area',);
    expect(result.entranceAisle, expectedEntranceAisle,
        reason: 'unexpected ticket entrance aisle',);
    expect(result.entranceGate, expectedEntranceGate,
        reason: 'unexpected ticket entrance gate',);
    expect(result.entranceCodes, expectedEntranceCodes,
        reason: 'unexpected ticket entrance codes',);
    expect(result.entrancePassageway, expectedEntrancePassageway,
        reason: 'unexpected ticket entrance passageway',);
    expect(result.entranceTurnstiles, expectedEntranceTurnstiles,
        reason: 'unexpected ticket entrance turnstiles',);
    expect(result.entranceStand, expectedEntranceStand,
        reason: 'unexpected ticket entrance stand',);
    expect(result.transferTo, expectedTransferTo,
        reason: 'unexpected ticket transfer to',);
    expect(result.transferTimestamp, expectedTransferTimeStamp,
        reason: 'unexpected ticket transfer time stamp',);
    expect(result.doorsOpenTimeOverride, expectedDoorsOpenTime,
        reason: 'unexpected ticket doors open time',);
    expect(result.eventTimeOverride, expectedEventTime,
        reason: 'unexpected ticket event time',);
    expect(result.endTimeOverride, expectedEndTime,
        reason: 'unexpected ticket end time',);

  });

}
