import 'package:dio/dio.dart';
import 'package:gigantic_ticket_wallet/network/common/Auth.dart';

/// common values used when querying the api
class APIConstants {

  /// get a basic setup of dio with base url and auth token
  static Dio getInstance() {
    final dio = Dio()
    ..options = BaseOptions(headers: {
      'Authorization': Auth.token,
    },
      preserveHeaderCase: true,
      baseUrl: 'https://www.gigantic.com/wallet_app/',
    );

    return dio;
  }
}
