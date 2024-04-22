import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';
import 'package:gigantic_ticket_wallet/database/ticket_database.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';
import 'package:gigantic_ticket_wallet/network/order_api.dart';
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
    final ticketDatabase = TicketDatabase(database: database);

    final repository = SyncScreenRepository(
        api: api,
        orderDatabase: orderDatabase,
        ticketDatabase: ticketDatabase,);

    await repository.syncOrders();

    final orders = await orderDatabase.getOrders();
    final tickets = await ticketDatabase.getTickets();

    expect(orders.isNotEmpty, true, reason: 'unexpected order list is empty');
    expect(tickets.isNotEmpty, true, reason: 'unexpected ticket list is empty');
  });
}

class MockOrderEndPoints extends OrderEndPointsInterface {
  @override
  Future<Response<dynamic>?> getAllOrders() async {
    const rawResponse = {
      'orders': {
        '7047174321686659bec78292b5012883437': {
          'order_ref': '0471-7459-4332',
          'billing_title': 'Mr',
          'billing_forename': 'Tobe ',
          'billing_surname': 'Kendrick',
          'event': {
            'event_title': 'Limp Bizkit',
            'venue_title': 'Dreamland',
            'event_start_time': '1718469000',
          },
          'tickets': {
            '7047174321798659bec782be84860353002': {
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
        },
      },
      'order_count': 15,
      'ticket_count': 36,
    };

    return Response(requestOptions: RequestOptions(), data: rawResponse);
  }
  
}
