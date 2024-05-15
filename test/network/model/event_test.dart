
import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/event.dart';

void main() {

  test('mapping json to event', () {

    const expectedPresentingText = 'presentingText';
    const expectedTitle = 'title';
    const expectedSubTitle = 'subTitle';
    const expectedStartTime = 1718469000;
    const expectedEventTime = 1718468000;
    const expectedEndTime = 1718467000;
    const expectedSeatingPlan = 'seatingPlan';
    const expectedVenue = 'venue';
    const expectedVenueAddress = 'venueAddress';
    const expectedVenueCity = 'venueCity';
    const expectedVenuePostCode = 'venuePostCode';
    const expectedVenueLatitude = 0.22;
    const expectedVenueLongitude = 1.33;
    const expectedVenueType = 'venueType';
    const expectedCampaignImage = 'campaignImage';
    const expectedEventImage = 'eventImage';
    const expectedRestriction = 'restriction';
    const expectedPromoterName = 'promoter';

    const eventJson = {
      'event_code': 'GEVT/70143616762956',
      'event_status': '1',
      'event_presenting_text': expectedPresentingText,
      'event_title': expectedTitle,
      'event_subtitle': expectedSubTitle,
      'event_start_time': '$expectedStartTime',
      'event_event_time': '$expectedEventTime',
      'event_end_time': '$expectedEndTime',
      'display_event_time': '1',
      'seating_plan': expectedSeatingPlan,
      'venue_title': expectedVenue,
      'venue_first_time': expectedVenueAddress,
      'venue_city': expectedVenueCity,
      'venue_postcode': expectedVenuePostCode,
      'venue_latitude': '$expectedVenueLatitude',
      'venue_longitude': '$expectedVenueLongitude',
      'venue_type': expectedVenueType,
      'campaign_image': expectedCampaignImage,
      'event_image': expectedEventImage,
      'age_restriction': expectedRestriction,
      'promoter_name': expectedPromoterName,
    };

    final event = Event.fromJson(eventJson);

    expect(event.presenter, expectedPresentingText,
        reason: 'unexpected event presenting text',);
    expect(event.title, expectedTitle, reason: 'unexpected event title');
    expect(event.subTitle, expectedSubTitle,
        reason: 'unexpected event sub title',);
    expect(event.doorsOpenTime?.millisecondsSinceEpoch, expectedStartTime * 1000,
      reason: 'unexpected event start time',);
    //startTimeJson is in seconds so converted to
    // milliseconds by multiplying by 1000
    expect(event.startTime?.millisecondsSinceEpoch, expectedEventTime * 1000,
        reason: 'unexpected event start time',);
    expect(event.endTime?.millisecondsSinceEpoch, expectedEndTime * 1000,
        reason: 'unexpected event end time',);
    expect(event.seatingPlan, expectedSeatingPlan,
        reason: 'unexpected event seating plan',);
    expect(event.venue, expectedVenue, reason: 'unexpected event venue');
    expect(event.venueAddress, expectedVenueAddress,
        reason: 'unexpected event venue address',);
    expect(event.venueCity, expectedVenueCity,
        reason: 'unexpected event venue city',);
    expect(event.venuePostcode, expectedVenuePostCode,
        reason: 'unexpected event venue postcode',);
    expect(event.venueLatitude, expectedVenueLatitude,
        reason: 'unexpected event venue latitude',);
    expect(event.venueLongitude, expectedVenueLongitude,
      reason: 'unexpected event venue longitude',);
    expect(event.venueType, expectedVenueType,
        reason: 'unexpected event venue type',);
    expect(event.campaignImage, expectedCampaignImage,
        reason: 'unexpected event campaign image',);
    expect(event.eventImage, expectedEventImage,
        reason: 'unexpected event image',);
    expect(event.restriction, expectedRestriction,
        reason: 'unexpected event restriction',);
    expect(event.promoter, expectedPromoterName,
        reason: 'unexpected event promoter',);

  });

}
