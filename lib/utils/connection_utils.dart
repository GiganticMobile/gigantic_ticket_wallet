import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// this checks of the app is connected to the internet
class ConnectionUtils extends ConnectionUtilsInterface {
  /// constructor
  ConnectionUtils({required InternetConnection internetConnection})
      : _internetConnection = internetConnection;

  final InternetConnection _internetConnection;

  @override
  Future<bool> hasInternetConnection() {
    return _internetConnection.hasInternetAccess;
  }

}

///
abstract class ConnectionUtilsInterface {
  /// checks if the app is connected to the internet
  Future<bool> hasInternetConnection();
}
