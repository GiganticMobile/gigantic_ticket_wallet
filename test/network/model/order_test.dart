import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart';

void main() {
  test('mapping json to order test', () {

    const expectedOrderId = '7047174321686659bec78292b5012883437';
    const expectedOrderReference = '0471-7459-4332';
    const expectedEvent = 'Limp Bizkit';
    const expectedVenue = 'Dreamland';
    const expectedStartTime = 1718469000;

    const expectedTicketId = '7047174321798659bec782be84860353002';

    final json = {
      'order_ref': expectedOrderReference,
      'billing_title': 'Mr',
      'billing_forename': 'Tobe ',
      'billing_surname': 'Kendrick',
      'event': {
        'event_title': expectedEvent,
        'venue_title': expectedVenue,
        'event_start_time': expectedStartTime.toString(),
      },
      'tickets': {
        expectedTicketId : {
          'barcode': '1517102976',
          'heading': 'General Admission Standing',
          'label': '',
          'face_value': '57.50',
        },
        '7047174321799659bec782beb4327541430': {
          'barcode': '1511097577',
          'heading': 'General Admission Standing',
          'label': '',
          'face_value': '57.50',
        },
      },
    };

    final order = Order.fromJson(expectedOrderId, json);

    expect(order.id, expectedOrderId, reason: 'unexpected order id');
    expect(order.orderReference, expectedOrderReference,
        reason: 'unexpected order reference',);
    expect(order.event, expectedEvent, reason: 'unexpected event');
    expect(order.venue, expectedVenue, reason: 'unexpected venue');
    //startTimeJson is in seconds so converted to
    // milliseconds by multiplying by 1000
    expect(order.startTime.millisecondsSinceEpoch, expectedStartTime * 1000,
        reason: 'unexpected start time',);
    //this test is not looking at mapping json to ticket so it just looks
    //at the ticket ids to check the the tickets exist in the order.
    expect(order.tickets.map((e) => e.id).toList(), contains(expectedTicketId),
        reason: 'unexpected ticket ids',);
  });
}
