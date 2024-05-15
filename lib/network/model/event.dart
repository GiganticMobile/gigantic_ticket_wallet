import 'package:gigantic_ticket_wallet/utils/date_utils.dart';

///this is used as part of the api response
class Event {

  ///constructor
  Event({
    required this.presenter,
    required this.title,
    required this.subTitle,
    required this.doorsOpenTime,
    required this.startTime,
    required this.endTime,
    required this.seatingPlan,
    required this.venue,
    required this.venueAddress,
    required this.venueCity,
    required this.venuePostcode,
    required this.venueLatitude,
    required this.venueLongitude,
    required this.venueType,
    required this.campaignImage,
    required this.eventImage,
    required this.restriction,
    required this.promoter,
  });

  /// json constructor
  Event.fromJson(dynamic json) {

    try {
    if (json case {
    'event_presenting_text': final String presenter,
    'event_title': final String title,
    'event_subtitle': final String subTitle,
    'event_start_time': final String startTime, //i.e. doors open
    'event_event_time': final String eventTime, //i.e event start
    'event_end_time': final String endTime, //i.e event ends
    'seating_plan': final String seatingPlan,
    //this is a url to a seating plan image
    'venue_title': final String venue,
    'venue_first_time': final String venueAddress, //fist line of the address
    'venue_city': final String venueCity,
    'venue_postcode': final String venuePostcode,
    'venue_latitude': final String venueLatitude,
    'venue_longitude': final String venueLongitude,
    'venue_type': final String venueType, //such as the venue is indoor
    'campaign_image': final String campaignImage,
    'event_image': final String eventImage,
    'age_restriction': final String restriction, //such as age restriction
    'promoter_name': final String promoter,
    }) {
      this.presenter = presenter;
      this.title = title;
      this.subTitle = subTitle;
      final doorsOpenTime = int.tryParse(startTime) ?? 0;
      if (doorsOpenTime != 0) {
        this.doorsOpenTime = CommonDateUtils.getDateFromInt(doorsOpenTime);
      } else {
        this.doorsOpenTime = null;
      }
      final eventStartTime = int.tryParse(eventTime) ?? 0;
      if (eventStartTime != 0) {
        this.startTime = CommonDateUtils.getDateFromInt(eventStartTime);
      } else {
        this.startTime = null;
      }
      final eventEndTime = int.tryParse(endTime) ?? 0;
      if (eventEndTime != 0) {
        this.endTime = CommonDateUtils.getDateFromInt(eventEndTime);
      } else {
        this.endTime = null;
      }
      this.seatingPlan = seatingPlan;
      this.venue = venue;
      this.venueAddress = venueAddress;
      this.venueCity = venueCity;
      this.venuePostcode = venuePostcode;
      this.venueLatitude = double.tryParse(venueLatitude);
      this.venueLongitude = double.tryParse(venueLongitude);
      this.venueType = venueType;
      this.campaignImage = campaignImage;
      this.eventImage = eventImage;
      this.restriction = restriction;
      this.promoter = promoter;
    } else {
      throw Exception('unable to map to json');
    }
  } catch (_) {
  throw Exception('unable to map to json');
  }

  }

  ///
  late final String presenter;
  ///
  late final String title;
  ///
  late final String subTitle;
  ///
  late final DateTime? doorsOpenTime;
  ///
  late final DateTime? startTime;
  ///
  late final DateTime? endTime;
  ///
  late final String seatingPlan;
  ///
  late final String venue;
  ///
  late final String venueAddress;
  ///
  late final String venueCity;
  ///
  late final String venuePostcode;
  ///
  late final double? venueLatitude;
  ///
  late final double? venueLongitude;
  ///
  late final String venueType;
  ///
  late final String campaignImage;
  ///
  late final String eventImage;
  ///
  late final String restriction;
  ///
  late final String promoter;

}
