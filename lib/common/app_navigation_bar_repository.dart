import 'package:gigantic_ticket_wallet/database/notification_database.dart';

///
class AppNavigationBarRepository extends AppNavigationBarRepositoryInterface {
  ///constructor
  AppNavigationBarRepository({
    required NotificationDatabaseInterface database,
  }) : _database = database;

  final NotificationDatabaseInterface _database;

  @override
  Future<bool> hasUnreadNotifications() {
    return _database.hasUnreadNotifications();
  }

}

///
abstract class AppNavigationBarRepositoryInterface {

  /// check if there are any notifications that the user has not seen
  /// and gives the result to the app navigation bar.
  Future<bool> hasUnreadNotifications();
}
