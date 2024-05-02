import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart';

void main() {
  test('mapping json to order test', () {

    const expectedOrderId = '7047174321686659bec78292b5012883437';
    const expectedOrderReference = '0471-7459-4332';
    const expectedHasRefundPlan = false;
    const expectedEvent = 'Limp Bizkit';

    const expectedTicketId = '7047174321798659bec782be84860353002';

    final json = {
      'order_id': '7047174321686659bec78292b5012883437',
      'order_ref': expectedOrderReference,
      'billing_title': 'Mr',
      'billing_forename': 'Tobe ',
      'billing_surname': 'Kendrick',
      'billing_first_line': 'Pl. de la Bastille 2',
      'billing_postcode': '75004',
      'phone_number': '+33153469302',
      'email_address': 'Tobe-Kendrick@vicecitymail.com',
      'order_complete_timestamp': '1704717579',
      'currency': 'GBP',
      'total_cost': '129.80',
      'order_has_refund_plan': expectedHasRefundPlan,
      'event': {
        'event_code': 'GEVT/70143616762956',
        'event_status': '1',
        'event_presenting_text': 'Soundcrash presents:',
        'event_title': expectedEvent,
        'event_subtitle': '',
        'event_start_time': '1718469000',
        'event_event_time': '0',
        'event_end_time': '0',
        'display_event_time': '1',
        'seating_plan': '',
        'venue_title': 'Dreamland',
        'venue_first_time': '49-51, Marine Terrace',
        'venue_city': 'Margate',
        'venue_postcode': 'CT9 1XJ',
        'venue_latitude': '51.386557',
        'venue_longitude': '1.377377',
        'venue_type': 'INDOOR',
        'campaign_image': 'limp_bizkit-7016794224.jpg',
        'event_image': '',
        'age_restriction': '10yrs+ (under 16s must be accompanied by an adult)',
        'promoter_name': 'Live Nation - Soundcrash',
      },
      'tickets': {
        expectedTicketId: {
          'barcode': '1517102976',
          'number': 'GIG7186902881',
          'heading': 'General Admission Standing',
          'label': '',
          'face_value': '57.50',
          'booking_fee': '6.90',
          'ticket_cancelled_timestamp': '0',
          'entrance_info': '',
          'entrance_area': '',
          'entrance_aisle': '',
          'entrance_gate': '',
          'entrance_codes': '',
          'entrance_passageway': '',
          'entrance_turnstiles': '',
          'entrance_stand': '',
          'transfer_to': '',
          'transfer_timestamp': 0,
          'ticket_count': 1,
          'start_time_override': '0',
          'event_time_override': '0',
          'end_time_override': '0',
        },
        '7047174321799659bec782beb4327541430': {
          'barcode': '1511097577',
          'number': 'GIG7585218254',
          'heading': 'General Admission Standing',
          'label': '',
          'face_value': '57.50',
          'booking_fee': '6.90',
          'ticket_cancelled_timestamp': '0',
          'entrance_info': '',
          'entrance_area': '',
          'entrance_aisle': '',
          'entrance_gate': '',
          'entrance_codes': '',
          'entrance_passageway': '',
          'entrance_turnstiles': '',
          'entrance_stand': '',
          'transfer_to': '',
          'transfer_timestamp': 0,
          'ticket_count': 2,
          'start_time_override': '0',
          'event_time_override': '0',
          'end_time_override': '0',
        },
      },
    };

    final order = Order.fromJson(expectedOrderId, json);

    expect(order.id, expectedOrderId, reason: 'unexpected order id');
    expect(order.orderReference, expectedOrderReference,
        reason: 'unexpected order reference',);
    expect(order.hasRefundPlan, expectedHasRefundPlan,
        reason: 'unexpected order has refund plan',);
    expect(order.event.title, expectedEvent, reason: 'unexpected event');
    //this test is not looking at mapping json to ticket so it just looks
    //at the ticket ids to check the the tickets exist in the order.
    expect(order.tickets.map((e) => e.id).toList(), contains(expectedTicketId),
        reason: 'unexpected ticket ids',);
  });
}
