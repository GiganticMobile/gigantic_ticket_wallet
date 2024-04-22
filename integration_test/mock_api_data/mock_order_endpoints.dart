import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/endpoints/order_end_points.dart';

class MockOrderEndPoints extends OrderEndPointsInterface {

  @override
  Future<Response<dynamic>?> getAllOrders() async {
    return Response(requestOptions: RequestOptions(), data: _ordersSuccessful);
  }

  final _ordersSuccessful = {
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

}
