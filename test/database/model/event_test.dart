import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/model/event.dart';
import 'package:gigantic_ticket_wallet/network/model/event.dart' as api;

void main() {

  test('check event from api maps to event database', () {

    const expectedOrderId = '1';
    const expectedPresenter = 'presenter';
    const expectedTitle = 'title';
    const expectedSubTitle = 'subTitle';
    const expectedDoorsOpenTime = 1000;
    const expectedStartTime = 2000;
    const expectedEndTime = 3000;
    const expectedSeatingPlan = 'seating Plan';
    const expectedVenue = 'venue';
    const expectedVenueAddress = 'venue address';
    const expectedVenueCity = 'venue city';
    const expectedVenuePostcode = 'venue postcode';
    const expectVenueLatitude = 10.0;
    const expectedVenueLongitude = 20.0;
    const expectedVenueType = 'venue type';
    const expectedCampaignImage = 'campaign image';
    const expectedEventImage = 'event image';
    const expectedRestriction = 'restriction';
    const expectedPromoter = 'promoter';

    final event = api.Event(
      presenter: expectedPresenter,
      title: expectedTitle,
      subTitle: expectedSubTitle,
      doorsOpenTime: DateTime.fromMillisecondsSinceEpoch(expectedDoorsOpenTime),
      startTime: DateTime.fromMillisecondsSinceEpoch(expectedStartTime),
      endTime: DateTime.fromMillisecondsSinceEpoch(expectedEndTime),
      seatingPlan: expectedSeatingPlan,
      venue: expectedVenue,
      venueAddress: expectedVenueAddress,
      venueCity: expectedVenueCity,
      venuePostcode: expectedVenuePostcode,
      venueLatitude: expectVenueLatitude,
      venueLongitude: expectedVenueLongitude,
      venueType: expectedVenueType,
      campaignImage: expectedCampaignImage,
      eventImage: expectedEventImage,
      restriction: expectedRestriction,
      promoter: expectedPromoter,
    );

    final result = Event.fromNetwork(expectedOrderId, event);

    expect(result.order, expectedOrderId, reason: 'unexpected order id');
    expect(result.presenter, expectedPresenter,
        reason: 'unexpected event presenter',);
    expect(result.title, expectedTitle, reason: 'unexpected event title');
    expect(result.subTitle, expectedSubTitle,
        reason: 'unexpected event sub title',);
    expect(result.doorsOpenTime, expectedDoorsOpenTime,
        reason: 'unexpected event door open time',);
    expect(result.startTime, expectedStartTime,
        reason: 'unexpected event start time',);
    expect(result.endTime, expectedEndTime,
        reason: 'unexpected event end time',);
    expect(result.seatingPlan, expectedSeatingPlan,
        reason: 'unexpected event seating plan',);
    expect(result.venue, expectedVenue,
        reason: 'unexpected event venue',);
    expect(result.venueAddress, expectedVenueAddress,
        reason: 'unexpected event venue address',);
    expect(result.venueCity, expectedVenueCity,
        reason: 'unexpected event venue city',);
    expect(result.venuePostcode, expectedVenuePostcode,
        reason: 'unexpected event venue postcode',);
    expect(result.venueLatitude, expectVenueLatitude,
        reason: 'unexpected event venue latitude',);
    expect(result.venueLongitude, expectedVenueLongitude,
        reason: 'unexpected venue longitude',);
    expect(result.venueType, expectedVenueType,
        reason: 'unexpected event venue type',);
    expect(result.campaignImage, expectedCampaignImage,
        reason: 'unexpected event campaign image',);
    expect(result.eventImage, expectedEventImage,
        reason: 'unexpected event image',);
    expect(result.restriction, expectedRestriction,
        reason: 'unexpected event restrictions',);
    expect(result.promoter, expectedPromoter,
        reason: 'unexpected event promoter',);

  });

}
