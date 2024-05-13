import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/network/model/event.dart';
import 'package:gigantic_ticket_wallet/network/model/order.dart' as api;

void main() {

  test('check order from api maps to order database', () {

    const expectedId = '2';
    const expectedOrderReference = '123-456-789';
    const expectedStartTime = 1000;
    const expectedHasRefundPlan = true;

    final order = api.Order(
      id: expectedId,
      orderReference: expectedOrderReference,
      //the event information does not matter for this test
      event: Event(
        presenter: '',
        title: '',
        subTitle: '',
        doorsOpenTime: DateTime.fromMillisecondsSinceEpoch(expectedStartTime),
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        seatingPlan: '',
        venue: '',
        venueAddress: '',
        venueCity: '',
        venuePostcode: '',
        venueLatitude: 0,
        venueLongitude: 0,
        venueType: '',
        campaignImage: '',
        eventImage: '',
        restriction: '',
        promoter: '',
      ),
      tickets: List.empty(),
      hasRefundPlan: expectedHasRefundPlan,
    );

    final result = Order.fromNetwork(order);

    expect(result.id, expectedId, reason: 'unexpected order id');
    expect(result.reference, expectedOrderReference,
        reason: 'unexpected order reference',);
    expect(result.hasRefundPlan, expectedHasRefundPlan,
        reason: 'unexpected order refund plan',);

    expect(result.startTime, expectedStartTime,
        reason: 'unexpected order start time',);

  });
}
