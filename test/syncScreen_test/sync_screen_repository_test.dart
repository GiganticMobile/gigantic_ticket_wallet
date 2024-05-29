import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/event_database.dart';
import 'package:gigantic_ticket_wallet/database/notification_database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_handler.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_settings.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen_repository.dart';

void main() {

  late AppDatabase database;

  setUp(() {
    database = AppDatabase.createInMemoryDatabase();
  });
  tearDown(() async {
    await database.close();
  });

  test('sync test', () async {

    final endpoints = MockOrderEndPoints();
    final api = OrderAPI(endPoints: endpoints);

    final orderDatabase = OrderDatabase(database: database);
    final eventDatabase = EventDatabase(database: database);
    final ticketDatabase = TicketDatabase(database: database);
    final notificationDatabase = NotificationDatabase(database: database);
    final notificationHandler = NotificationHandler(
        notificationDatabase: notificationDatabase,
        notificationSettings: MockNotificationSettings(),
    );

    final repository = SyncScreenRepository(
        api: api,
        orderDatabase: orderDatabase,
        eventDatabase: eventDatabase,
        ticketDatabase: ticketDatabase,
        notificationHandler: notificationHandler,
    );

    await repository.syncOrders();

    final orders = await orderDatabase.getOrders();
    final events = await eventDatabase.getEvents();
    final tickets = await ticketDatabase.getTickets();

    expect(orders.isNotEmpty, true, reason: 'unexpected order list is empty');
    expect(events.isNotEmpty, true, reason: 'unexpected event list is empty');
    expect(tickets.isNotEmpty, true, reason: 'unexpected ticket list is empty');
  });
}

class MockOrderEndPoints extends OrderEndPointsInterface {
  @override
  Future<Response<dynamic>?> getAllOrders() async {
    const rawResponse = {
      'orders': {
        '7047174321686659bec78292b5012883437': {
          'order_id': '7047174321686659bec78292b5012883437',
          'order_ref': '0471-7459-4332',
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
          'order_has_refund_plan': false,
          'event': {
            'event_code': 'GEVT/70143616762956',
            'event_status': '1',
            'event_presenting_text': 'Soundcrash presents:',
            'event_title': 'Limp Bizkit',
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
            'campaign_image': 'https://cdn2.gigantic.com/static/images/campaign/820x500/limp_bizkit-7016794224.jpg',
            'event_image': '',
            'age_restriction': '10yrs+ (under 16s must be accompanied by an adult)',
            'promoter_name': 'Live Nation - Soundcrash',
          },
          'tickets': {
            '7047174321798659bec782be84860353002': {
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
          },
        },
      },
      'transfers': <String>[],
      'order_count': 15,
      'ticket_count': 36,
    };

    return Response(requestOptions: RequestOptions(), data: rawResponse);
  }
  
}

class MockNotificationSettings implements NotificationSettingsInterface {
  @override
  Future<bool> getAllowedNotificationsOption() async {
    return false;
  }

  @override
  Future<bool> getOnlyUpdatesOption() async {
    return false;
  }

  @override
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {

  }

  @override
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {

  }

}
